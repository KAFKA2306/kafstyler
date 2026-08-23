# basic_prompts

Private repository for reusable prompts, agent instructions, durable ChatGPT memory, and Agent Skills.

## Skills

- [`skills/finance/SKILL.md`](skills/finance/SKILL.md): turn a finance question into a verified keep / reject / revise / unknown decision.
- [`skills/games/SKILL.md`](skills/games/SKILL.md): improve game and board-game products with edition-safe rules, player value, revenue awareness, and production verification.
- [`skills/pages/SKILL.md`](skills/pages/SKILL.md): design public Pages around what visitors actually want to understand or do.
- [`skills/research-data/SKILL.md`](skills/research-data/SKILL.md): turn research questions and source material into trustworthy, reusable data and evidence-backed results with minimal complexity.
- [`skills/sanitize-artifacts/SKILL.md`](skills/sanitize-artifacts/SKILL.md): turn iterative or conversation-shaped drafts into clean standalone deliverables.
- [`skills/vr-3d/SKILL.md`](skills/vr-3d/SKILL.md): build VR/3D/spatial assets, tools, and experiences around reusable artifacts, real consumer evidence, distribution, and revenue.

## ChatGPT memory

- `MEMORY.md`: canonical durable state. `main` = current, PR diff = proposed change, Git history = past.
- `CHATGPT_MEMORY_PROMPT.md`: paste-ready prompt for auditing/syncing ChatGPT against `main/MEMORY.md`.

Edit memory through a PR, review the semantic diff, then run:

```bash
python -m unittest tests.test_memory_contract -v
```

Mutable state stays in its source of truth, not in memory.
