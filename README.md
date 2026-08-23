# basic_prompts

Private repository for reusable prompts, agent instructions, and the canonical durable ChatGPT memory.

## ChatGPT memory

`MEMORY.md` is the source of truth for durable ChatGPT memory. It stores stable preferences, operating principles, and source routing only. Current project state, prices, versions, schedules, CI/deployment results, and other mutable facts are retrieved from their actual sources when needed.

`CHATGPT_MEMORY_PROMPT.md` is the single reusable prompt to paste into ChatGPT when auditing ChatGPT-side memory against `main/MEMORY.md`. It references the canonical memory instead of copying its values.

### Compare current and proposed state

Use Git itself as the state model:

- `main/MEMORY.md` = current durable memory.
- PR head `MEMORY.md` = proposed durable memory.
- GitHub PR diff = current-to-proposed comparison.
- Git history = superseded durable memory.

Keep one durable memory item per top-level bullet and preserve section order. Update an existing rule by replacing or deleting its bullet; do not append old and new versions together.

For memory-changing PRs, summarize semantic changes as `ADD`, `REPLACE`, `DELETE`, and `MOVE-OUT`. `MOVE-OUT` means a mutable value leaves durable memory and is retrieved from its source of truth instead.

Validate memory changes locally:

```bash
python scripts/validate_memory.py
python -m unittest tests.test_memory_contract
```

ChatGPT Saved Memory is treated as a derived cache. Git history preserves superseded memory; the current `main` version of `MEMORY.md` is authoritative.
