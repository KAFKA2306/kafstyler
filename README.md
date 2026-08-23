# basic_prompts

Private repository for reusable prompts, agent instructions, and the canonical durable ChatGPT memory.

## ChatGPT memory

`MEMORY.md` is the source of truth for durable ChatGPT memory. It stores stable preferences, operating principles, and source routing only. Current project state, prices, versions, schedules, CI/deployment results, and other mutable facts are retrieved from their actual sources when needed.

Validate memory changes locally:

```bash
python scripts/validate_memory.py
python -m unittest tests.test_memory_contract
```

ChatGPT Saved Memory is treated as a derived cache. Git history preserves superseded memory; the current `main` version of `MEMORY.md` is authoritative.
