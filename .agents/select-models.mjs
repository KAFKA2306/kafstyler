#!/usr/bin/env node
// Select across the global Pareto frontier, then retain a separate-provider fallback.
// Public data only. No paid API and no private API key.
import {readFile,writeFile} from 'node:fs/promises';
import {dirname,resolve,join} from 'node:path';
import {fileURLToPath} from 'node:url';
import {createHash} from 'node:crypto';

const root=resolve(dirname(fileURLToPath(import.meta.url)),'..');
const policyPath=join(root,'.agents/model-policy.json');
const resultPath=join(root,'.agents/model-selection.json');
const argv=process.argv.slice(2);
const opt=x=>{let i=argv.indexOf(x);return i<0?null:argv[i+1];};
const now=opt('--as-of')||new Date().toISOString().slice(0,10);
const fail=s=>{throw Error(s);};
const check=(v,s)=>{if(!v)fail(s);};
const dateDiff=s=>(Date.parse(now+'T00:00:00Z')-Date.parse(s+'T00:00:00Z'))/86400000;
const validNum=x=>typeof x==='number'&&Number.isFinite(x)&&x>=0;

async function fetchJson(url,repo) {
  check(url.startsWith('https://raw.githubusercontent.com/'+repo+'/main/data/'),'Unexpected source URL');
  const r=await fetch(url,{signal:AbortSignal.timeout(30000)});
  check(r.ok,'Public source HTTP '+r.status);
  return r.json();
}
function assertFresh(date,maxDays){
  const age=dateDiff(date);
  check(Number.isFinite(age)&&age>=0&&age<=maxDays,'Data stale or future-dated: '+date);
}
function pareto(a){
  return a.filter(x=>!a.some(y=>x!==y&&y.score>=x.score&&y.price<=x.price&&(y.score>x.score||y.price<x.price)));
}
function rank(a,b,method){
  if(method==='highest_score')return b.score-a.score||a.price-b.price||a.id.localeCompare(b.id);
  if(method==='score_per_dollar')return b.score/b.price-a.score/a.price||b.score-a.score||a.price-b.price||a.id.localeCompare(b.id);
  fail('Unknown selection criterion '+method);
}
function normalized(snapshot,cfg){
  check(snapshot.meta?.source_url===cfg.benchmark_source.url,'Provenance mismatch');
  check(Array.isArray(snapshot.models)&&snapshot.models.length>=20,'Insufficient benchmark data');
  const original=snapshot.meta.original_date||snapshot.meta.fetched_at?.slice(0,10);
  check(original,'Missing underlying benchmark date');
  assertFresh(original,cfg.benchmark_source.max_source_age_days);
  const rows=new Map();
  for(const m of snapshot.models){
    if(m.deprecated||!m.slug||!m.name||!cfg.providers.includes(m.creator?.name))continue;
    const score=m.evaluations?.[cfg.benchmark];
    const input=m.pricing?.price_1m_input_tokens;
    const output=m.pricing?.price_1m_output_tokens;
    if(!validNum(score)||m.evaluations?.[cfg.benchmark+'_is_estimated']===true||!validNum(input)||!validNum(output))continue;
    const price=+((input*cfg.price.input_weight+output*cfg.price.output_weight)*cfg.price.discount_multiplier).toFixed(6);
    if(!(price>0&&price<=cfg.price.max_usd))continue;
    const row={id:m.slug,name:m.name,provider:m.creator.name,score:+score.toFixed(4),price};
    check(!rows.has(row.id)||JSON.stringify(rows.get(row.id))===JSON.stringify(row),'Duplicate model conflict '+row.id);
    rows.set(row.id,row);
  }
  return {rows:[...rows.values()].sort((a,b)=>a.id.localeCompare(b.id)),date:original};
}
export function choose(snapshot,cfg){
  const {rows,date}=normalized(snapshot,cfg);
  const result={schema_version:1,status:'benchmark_selected_runtime_unverified',updated_from_benchmark:date,
    source:cfg.benchmark_source.url,pricing:cfg.price,skills:{}};
  check(Object.keys(cfg.skill_roles).length===7,'Expected seven existing skill names');
  for(const name of Object.keys(cfg.skill_roles).sort()){
    const role=cfg.skill_roles[name];
    const rule=cfg.roles[role];
    check(rule,'Unknown model role '+role);
    const allowed=rows.filter(x=>x.score>=(rule.min_score||0));
    check(new Set(allowed.map(x=>x.provider)).size>=2,'Insufficient independent providers for '+name);
    const global=pareto(allowed).sort((a,b)=>rank(a,b,rule.criterion));
    check(global.length,'No Pareto candidate for '+name);
    const first=global[0];
    // Fallback can be dominated. It is redundancy for rate limits, not another Pareto winner.
    const secondary=allowed.filter(x=>x.provider!==first.provider).sort((a,b)=>rank(a,b,rule.criterion))[0];
    check(secondary,'No different-provider fallback for '+name);
    result.skills[name]={
      primary:{name:first.name,provider:first.provider,score:first.score,price:first.price,model_id:null},
      fallback:{name:secondary.name,provider:secondary.provider,score:secondary.score,price:secondary.price,model_id:null},
      fallback_reason:'provider weekly quota or service outage'
    };
  }
  result.snapshot_sha256=createHash('sha256').update(JSON.stringify(snapshot)).digest('hex');
  return result;
}
async function main(){
  const cfg=JSON.parse(await readFile(policyPath,'utf8'));
  const pick=opt('--resolve');
  if(pick){
    const saved=JSON.parse(await readFile(resultPath,'utf8'));
    check(saved.skills[pick],'Unknown skill '+pick);
    const row=saved.skills[pick];
    const unavailable=opt('--unavailable');
    const selected=unavailable===row.primary.provider?row.fallback:row.primary;
    process.stdout.write(JSON.stringify({skill:pick,model:selected,source_status:saved.status})+'\n');
    return;
  }
  if(argv.includes('--baseline')){
    console.log(JSON.stringify(Object.fromEntries(Object.entries(cfg.skill_roles).map(([k,role])=>[k,cfg.roles[role].bootstrap])),null,2));
    return;
  }
  try {
    let snapshot;
    if(opt('--fixture'))snapshot=JSON.parse(await readFile(resolve(opt('--fixture')),'utf8'));
    else {
      const pointer=await fetchJson(cfg.benchmark_source.pointer,cfg.benchmark_source.repository);
      check(/^data\/\d{4}-\d{2}-\d{2}$/.test(pointer.path),'Invalid public snapshot path');
      assertFresh(pointer.date,cfg.benchmark_source.max_source_age_days);
      snapshot=await fetchJson('https://raw.githubusercontent.com/'+cfg.benchmark_source.repository+'/main/'+pointer.path+'/llms.json',cfg.benchmark_source.repository);
    }
    const result=choose(snapshot,cfg);
    const content=JSON.stringify(result,null,2)+'\n';
    if(argv.includes('--write')){
      const previous=await readFile(resultPath,'utf8').catch(()=>null);
      if(previous!==content)await writeFile(resultPath,content,'utf8');
      console.log('Model selection: '+result.updated_from_benchmark);
    }else process.stdout.write(content);
  }catch(error){
    if(argv.includes('--write')&&!opt('--fixture')){
      console.warn('Model selection retained unchanged: '+error.message);
      return;
    }
    throw error;
  }
}
main().catch(e=>{console.error('Model selection failed: '+e.message);process.exitCode=1;});
