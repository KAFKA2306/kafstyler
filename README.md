# basic_prompts

Private compatibility repository for legacy/lightweight prompts, repository-local agent instructions, durable ChatGPT memory, and existing Agent Skills.

## Ownership boundary

New reusable prompts and formal reusable artifacts are registered in `KAFKA2306/prompt-vault`, not here. Raw facts, episodes, lessons, failures, and corrections belong in `KAFKA2306/graphiti`; do not copy Graphiti raw knowledge into this repository.

`prompt-boundary.json` is the machine-readable inventory and routing contract for what remains here. It distinguishes retained compatibility content from content that belongs in Prompt Vault or Graphiti. Secrets and private source material must never be promoted to a public surface.

## Skills

- [`skills/finance/SKILL.md`](skills/finance/SKILL.md): finance decisions with point-in-time evidence, baselines, OOS evaluation, costs, and risk.
- [`skills/games/SKILL.md`](skills/games/SKILL.md): game and board-game work with edition-safe rules and first-party rule authority.
- [`skills/human-memory/SKILL.md`](skills/human-memory/SKILL.md): human-memory systems with provenance, revision history, privacy boundaries, and public projection control.
- [`skills/pages/SKILL.md`](skills/pages/SKILL.md): public Pages and dashboards around what visitors actually want to understand or do.
- [`skills/research-data/SKILL.md`](skills/research-data/SKILL.md): research/data work where source identity, provenance, deduplication, reproducibility, and baseline comparison matter.
- [`skills/vr-3d/SKILL.md`](skills/vr-3d/SKILL.md): VR/3D/spatial work with artifact lineage, consumer-target verification, distribution, and runtime constraints.

Generic repository, verification, and artifact-finalization rules belong in `AGENTS.md`; Skills contain existing domain-specific decision rules. Do not add a new reusable prompt here merely because a Skill references it.

## ChatGPT memory

- `MEMORY.md`: canonical durable state. `main` = current, PR diff = proposed change, Git history = past.
- `CHATGPT_MEMORY_PROMPT.md`: repository-local compatibility helper for auditing/syncing ChatGPT against `main/MEMORY.md`; it is not the standard registration location for new reusable prompts.

Edit memory through a PR, review the semantic diff, then run:

```bash
python -m unittest tests.test_memory_contract -v
```

Mutable state stays in its source of truth, not in memory.


## Autonomy contract

Repeated operating instructions are encoded once in [`policies/autonomy_contract.json`](policies/autonomy_contract.json) and enforced with [`tools/autonomy_contract.py`](tools/autonomy_contract.py).

The CLI can compile a profile-specific agent prompt, initialize a machine-auditable run ledger, reject unsupported completion claims, and return the next incomplete gate. See [`docs/autonomy_contract.md`](docs/autonomy_contract.md).
