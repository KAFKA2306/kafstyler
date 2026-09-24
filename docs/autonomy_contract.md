# Autonomy Contract

`tools/autonomy_contract.py` turns repeated operating instructions into a deterministic execution contract that agents can consume and a run record that machines can audit.

The design deliberately separates four things:

1. `policies/autonomy_contract.json` is the canonical policy.
2. `prompt` compiles the policy into a paste-ready instruction for an agent.
3. `init-run` creates a run ledger with explicit gates.
4. `audit` and `next` prevent an agent from calling a task complete while required evidence is missing.

No daemon is required. The tool is stdlib-only and can be called from Codex, OpenClaw, shell scripts, scheduled jobs, or another orchestrator.

## Examples

```bash
python tools/autonomy_contract.py profiles
python tools/autonomy_contract.py prompt --profile repo --task "Resolve issue #196"
python tools/autonomy_contract.py init-run --profile research_data --task "Refresh the canonical CapEx dataset" > run.json
python tools/autonomy_contract.py audit run.json
python tools/autonomy_contract.py next run.json
```

A gate marked `done` or `pass` is still incomplete when that gate requires evidence and its evidence list is empty. This makes "did not run = PASS" impossible at the contract layer.

## Profiles

- `general`: inspect → act → verify → summarize
- `repo`: current state → implementation → checks → canonical PR → exact-head CI → merge → main read-back → cleanup
- `research_data`: scope → primary evidence → raw capture → canonicalization → completeness audit → publish
- `investment`: point-in-time evidence → primary financials → operating bridge → scenario → risk → decision record
- `image`: brief → simplification → render → visual review

Add domain-specific policy to the relevant Skill when it is a domain rule. Add a gate here only when it should be enforced mechanically across repeated runs.
