#!/usr/bin/env node
// Deterministic third-party recommendations, not model execution.
import {readFile,writeFile,readdir} from 'node:fs/promises';
import {dirname,join} from 'node:path';
import {fileURLToPath} from 'node:url';

const root=join(dirname(fileURLToPath(import.meta.url)),'..');
const argv=process.argv.slice(2);
const arg=x=>argv.includes(x)?argv[argv.indexOf(x)+1]:null;
const policy=arg('--policy');
if(!policy)throw Error('Specify deployment policy with --policy PATH');
const cfg=JSON.parse(await readFile(policy,'utf8'));
const today=arg('--as-of')||new Date().toISOString().slice(0,10);
const fail=(ok,message)=>{if(!ok)throw Error(message)};
const age=s=>(Date.parse(today+'T00:00:00Z')-Date.parse(s+'T00:00:00Z'))/86400000;
const valid=x=>typeof x==='number'&&Number.isFinite(x);

async function get(url){
  const r=await fetch(url,{signal:AbortSignal.timeout(30000)});
  fail(r.ok,'Public data HTTP '+r.status);
  return r.json();
}
function choose(data,names){
  fail(data.meta?.source_url===cfg.benchmark_source.url,'Unexpected benchmark source');
  const date=data.meta.original_date||data.meta.fetched_at?.slice(0,10);
  const days=age(date);
  fail(valid(days)&&days>=0&&days<=cfg.benchmark_source.max_source_age_days,'Benchmark stale or undated');
  fail(Array.isArray(data.models),'Missing benchmark models');
  const entries=new Map();
  for(const m of data.models){
    const s=m.evaluations?.[cfg.benchmark],i=m.pricing?.price_1m_input_tokens;
    const o=m.pricing?.price_1m_output_tokens;
    if(m.deprecated||!m.slug||!m.name||!cfg.providers.includes(m.creator?.name)||
       !valid(s)||s<=0||m.evaluations?.[cfg.benchmark+'_is_estimated']===true||
       !valid(i)||i<0||!valid(o)||o<0)continue;
    const price=+(i*cfg.price.input_weight+o*cfg.price.output_weight).toFixed(6);
    if(price<=0||price>cfg.price.max_usd)continue;
    const model={id:m.slug,name:m.name,provider:m.creator.name,score:+s.toFixed(4),price};
    fail(!entries.has(model.id)||JSON.stringify(entries.get(model.id))===JSON.stringify(model),'Duplicate ID');
    entries.set(model.id,model);
  }
  const rows=[...entries.values()].sort((a,b)=>a.id.localeCompare(b.id));
  fail(rows.length>0,'No measured models');
  const maxScore=Math.max(...rows.map(x=>x.score));
  const pool=rows.filter(x=>x.score>=maxScore*cfg.quality_fraction);
  fail(new Set(pool.map(x=>x.provider)).size>=2,'No independent-provider fallback');
  const frontier=pool.filter(a=>!pool.some(b=>a!==b&&b.score>=a.score&&b.price<=a.price&&
    (b.score>a.score||b.price<a.price)));
  const rank=(a,b,audit)=>audit
    ? b.score-a.score||a.price-b.price||a.id.localeCompare(b.id)
    : b.score/b.price-a.score/a.price||b.score-a.score||a.price-b.price||a.id.localeCompare(b.id);
  const result={schema_version:2,status:'benchmark_selected_runtime_unverified',
    updated_from_benchmark:date,source:cfg.benchmark_source.url,retrieved_via:cfg.benchmark_source.pointer,pricing:cfg.price,skills:{}};
  for(const name of names.sort()){
    const audit=cfg.score_first.includes(name);
    const first=[...frontier].sort((a,b)=>rank(a,b,audit))[0];
    const backup=pool.filter(x=>x.provider!==first.provider).sort((a,b)=>rank(a,b,audit))[0];
    fail(backup,'Missing fallback for '+name);
    result.skills[name]={
      primary:{name:first.name,provider:first.provider,score:first.score,price:first.price,benchmark_slug:first.id,model_id:null},
      fallback:{name:backup.name,provider:backup.provider,score:backup.score,price:backup.price,benchmark_slug:backup.id,model_id:null},
      fallback_reason:'provider weekly quota or service outage'
    };
  }
  return result;
}
async function skillNames(){
  const names=[];
  for(const e of await readdir(join(root,'skills'),{withFileTypes:true})){
    if(!e.isDirectory())continue;
    const body=await readFile(join(root,'skills',e.name,'SKILL.md'),'utf8');
    fail(new RegExp('^name: '+e.name+'$','m').test(body.split('\n---\n')[0]),'Skill name mismatch: '+e.name);
    names.push(e.name);
  }
  fail(names.length>0&&cfg.score_first.every(x=>names.includes(x)),'Skill configuration mismatch');
  return names;
}
async function main(){
  const output=arg('--output');
  if((argv.includes('--write')||arg('--resolve'))&&!output)throw Error('Specify deployment output with --output PATH');
  const selectedName=arg('--resolve');
  if(selectedName){
    const saved=JSON.parse(await readFile(output,'utf8'));
    fail(saved.status==='benchmark_selected_runtime_unverified'&&saved.skills[selectedName],
      'Selection unavailable');
    fail(saved.source===cfg.benchmark_source.url,'Unexpected saved benchmark source');
    const days=age(saved.updated_from_benchmark);
    fail(valid(days)&&days>=0&&days<=cfg.benchmark_source.max_source_age_days,'Saved benchmark stale or undated');
    const m=saved.skills[selectedName];
    const useFallback=argv.includes('--fallback')||arg('--unavailable')===m.primary.provider;
    console.log(JSON.stringify({skill:selectedName,model:useFallback?m.fallback:m.primary,source_status:saved.status,execution_ready:false}));
    return;
  }
  const names=await skillNames();
  let data;
  if(arg('--fixture'))data=JSON.parse(await readFile(arg('--fixture'),'utf8'));
  else{
    const pointer=await get(cfg.benchmark_source.pointer);
    fail(/^data\/\d{4}-\d\d-\d\d$/.test(pointer.path),'Unexpected snapshot path');
    const days=age(pointer.date);
    fail(valid(days)&&days>=0&&days<=cfg.benchmark_source.max_source_age_days,'Snapshot pointer stale');
    data=await get('https://raw.githubusercontent.com/'+cfg.benchmark_source.repository+
      '/main/'+pointer.path+'/llms.json');
  }
  const result=choose(data,names);
  const text=JSON.stringify(result,null,2)+'\n';
  if(argv.includes('--write')){
    await writeFile(output,text,'utf8');
  }else process.stdout.write(text);
}
await main();
