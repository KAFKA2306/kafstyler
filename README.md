# basic_prompts

Private repository for reusable prompts, agent instructions, and durable ChatGPT memory.

## ChatGPT memory

- `MEMORY.md`: canonical durable state. `main` = current, PR diff = proposed change, Git history = past.
- `CHATGPT_MEMORY_PROMPT.md`: paste-ready prompt for auditing/syncing ChatGPT against `main/MEMORY.md`.

Edit memory through a PR, review the semantic diff, then run:

```bash
python -m unittest tests.test_memory_contract -v
```

Mutable state stays in its source of truth, not in memory.
