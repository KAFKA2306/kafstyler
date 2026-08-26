# basic_prompts

Private repository for reusable prompts, agent instructions, durable ChatGPT memory, and Agent Skills.

## Skills

- [`skills/finance/SKILL.md`](skills/finance/SKILL.md): finance decisions with point-in-time evidence, baselines, OOS evaluation, costs, and risk.
- [`skills/games/SKILL.md`](skills/games/SKILL.md): game and board-game work with edition-safe rules and first-party rule authority.
- [`skills/human-memory/SKILL.md`](skills/human-memory/SKILL.md): human-memory systems with provenance, revision history, privacy boundaries, and public projection control.
- [`skills/pages/SKILL.md`](skills/pages/SKILL.md): public Pages and dashboards around what visitors actually want to understand or do.
- [`skills/research-data/SKILL.md`](skills/research-data/SKILL.md): research/data work where source identity, provenance, deduplication, reproducibility, and baseline comparison matter.
- [`skills/vr-3d/SKILL.md`](skills/vr-3d/SKILL.md): VR/3D/spatial work with artifact lineage, consumer-target verification, distribution, and runtime constraints.

Generic repository, verification, and artifact-finalization rules belong in `AGENTS.md`; Skills should contain domain-specific decision rules.

## ChatGPT memory

- `MEMORY.md`: canonical durable state. `main` = current, PR diff = proposed change, Git history = past.
- `CHATGPT_MEMORY_PROMPT.md`: paste-ready prompt for auditing/syncing ChatGPT against `main/MEMORY.md`.

Edit memory through a PR, review the semantic diff, then run:

```bash
python -m unittest tests.test_memory_contract -v
```

Mutable state stays in its source of truth, not in memory.
