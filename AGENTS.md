# Private Repository Agent Contract

This repository is private. Keep development, verification, release, and cleanup operable with zero mandatory GitHub-hosted Actions spend.

## Knowledge and Prompt Ownership

- `prompt-boundary.json` is the machine-readable routing/inventory contract for content retained in this repository.
- Register new reusable prompts and formal reusable artifacts in `KAFKA2306/prompt-vault`; do not make `basic_prompts` a second current prompt authority.
- Store raw facts, episodes, lessons, failures, and corrections in `KAFKA2306/graphiti`; do not copy Graphiti raw knowledge into this repository.
- Existing content marked `remain` in `prompt-boundary.json` is retained only for its stated repository-local compatibility role.
- Never promote secrets or private source material to a public repository or artifact.

## Zero-Cost Rule

- Do not add or require GitHub-hosted runners (`ubuntu-latest`, `windows-latest`, `macos-latest`, or equivalent) unless the user explicitly changes the cost contract.
- Run tests, lint, builds, data checks, and artifact generation locally or in the active agent environment using the repository's actual toolchain.
- A GitHub Actions Billing/spending-limit failure is an infrastructure condition, not source-code test evidence. Do not retry a billing-blocked hosted workflow as the normal recovery route.
- If self-hosted Actions are ever introduced, document the runner host, security boundary, and availability; self-hosting must not become an implicit completion dependency.

## Git / PR / Cleanup

- Use GitHub API/connector operations for Issue, PR, commit, merge, and repository-state work where available; these do not require a GitHub-hosted runner.
- Do not create a workflow solely to merge, close, or delete a branch.
- Prefer GitHub's native `Automatically delete head branches` setting for merged PR cleanup; otherwise use an available API/UI deletion path.
- Keep one canonical branch/PR for one outcome. Do not create duplicates to work around a rejected write.
- If a host-side safety system rejects a GitHub write, re-fetch current state and retry the exact canonical action once. If rejected again, preserve the single canonical workline and report the blocker.

## Artifact final pass

For any finished artifact, make it stand alone for its intended audience. Remove prompt/conversation history, revision commentary, tool scaffolding, incidental examples, and other production meta unless the reader needs it to understand, trust, use, or verify the result. Unify terminology, assumptions, structure, and voice rather than preserving seams from iterative editing.

## ChatGPT Memory

- `MEMORY.md` is the only canonical durable memory; `CHATGPT_MEMORY_PROMPT.md` only tells ChatGPT how to audit/sync it and must not duplicate its values.
- Use `main/MEMORY.md` as current state, PR diff as proposed change, and Git history as past state; keep one durable item per bullet and replace/delete instead of appending old states.
- Keep mutable current state, credentials, secrets, and unnecessary sensitive data out of memory; retrieve current values from their owning source.
- Treat ChatGPT Saved Memory as a derived cache; if editable, keep only a pointer to current `main/MEMORY.md` rather than duplicating durable items.
- Verify memory changes with `python -m unittest tests.test_memory_contract -v`.

## Verification

- Derive verification commands from the repository's current README, package/build files, and executable configuration rather than inventing CI-only checks.
- Record exactly which checks ran and their results. A check that did not run is not PASS.
- Merge only when the requested contract is provable without depending on paid hosted CI.

## Completion

Before reporting completion, verify relevant source state, tests/builds actually executed, PR/main state, and cleanup. Do not treat billing-gated hosted CI as a completion requirement for this private repository.
