# GitHub Write Transaction Protocol

## Purpose

ChatGPT-driven GitHub automation must not treat a single connector/tool response as the source of truth for external writes. Branch creation, commit/ref/file writes, pull-request creation, merge, issue close, and cleanup are handled as idempotent transactions whose authoritative result is the state read back from GitHub.

This contract is repository-agnostic and is intended for KAFKA2306 autonomous GitHub workflows.

## Core invariant

For every external GitHub write:

1. **Preflight** — identify the canonical target and capture its precondition state.
2. **Write once** — execute the canonical GitHub action.
3. **Read back** — fetch the authoritative GitHub state immediately after the action.
4. **Reconcile** — if the intended state already exists, treat the transaction as successful regardless of an ambiguous connector result.
5. **Retry once only when absent** — if the intended state is absent and the precondition still permits the same action, repeat exactly the same intent once.
6. **Carry the same identity forward** — after a second host-side rejection, preserve one canonical workline and retry from read-back on the next scheduled run. Do not fork the intent into a second branch or PR.

A host-side safety rejection is not, by itself, evidence of expired authentication, a GitHub permission failure, or a requirement for user UI interaction.

## Canonical identities

| Operation | Identity / precondition | Success proof |
| --- | --- | --- |
| Create branch | repository + branch name + base SHA | exact branch exists at the intended base or canonical descendant |
| File/blob/tree/commit/ref write | repository + target branch/path + expected prior SHA | target content/ref points to intended resulting state |
| Create PR | repository + head branch + base branch | one open PR exists for the exact head/base pair |
| Merge PR | PR + expected head SHA | PR is merged and/or base contains the merge result |
| Close issue | issue + satisfied acceptance criteria / merged resolving PR | issue state is closed with the intended resolution |
| Cleanup | merged/obsolete workline identity | obsolete workline is absent; unrelated work remains intact |

## Branch creation

- Resolve and pin the current base SHA before creation.
- Search for the exact branch name before writing.
- After `create_branch`, search/read the same branch again.
- If the branch exists, continue even if the connector reported a host-side rejection or ambiguous result.
- If it does not exist and the base precondition is still valid, retry the same branch name and same intent once.
- Never create a differently named fallback branch solely to bypass a rejected write.

GitHub's Create a reference API returns `201` when created and explicit GitHub-side errors such as `409` or `422` for conflicts/validation failures. The branch/ref read-back is therefore the authoritative reconciliation step.

Primary source: https://docs.github.com/en/rest/git/refs

## Commit, file, and ref writes

- Capture the target branch/path and prior SHA before writing.
- After the write, read the target branch, file, or resulting commit.
- If the intended content/SHA is present, mark success.
- If absent and the prior-state precondition remains valid, retry the identical write once.
- If the target moved, re-read and reconstruct against the new canonical state; do not force-overwrite unrelated work and do not escape to a duplicate branch.

## Pull-request creation

- Define the PR identity as exact `head + base`.
- Search open PRs for the exact pair before `create_pull_request`.
- Search again immediately after the write.
- If one open PR exists for the pair, adopt it as canonical regardless of an ambiguous connector result.
- If none exists, retry the same head/base/title/body once.
- Never create a second PR from another branch to work around a host-side rejection.

Primary source: https://docs.github.com/en/rest/pulls/pulls

## CI and review gate

Before merge, re-read the exact PR head SHA and verify the current required/relevant CI, Draft state, mergeability, unresolved review threads, and explicit blockers in the PR/linked issue.

Do not merge Draft PRs, PRs with failed required CI, or PRs with an explicit unresolved external/target-machine/review blocker.

## Merge

- Pin the current PR head SHA.
- When immediately mergeable, use squash merge with `expected_head_sha` where supported.
- If repository-native auto-merge is enabled and the PR is only waiting on GitHub merge requirements, prefer native auto-merge.
- Read the PR and base branch after the merge action.
- If the PR is already merged, treat the transaction as successful even if the connector result was ambiguous.
- If still unmerged and the exact head SHA is unchanged, retry the same merge intent once.
- Do not ask the user to click Merge solely because the connector's host-side safety layer rejected the action.

GitHub exposes explicit expected-head protections and native auto-merge primitives for this purpose.

Primary sources:
- https://docs.github.com/en/rest/pulls/pulls
- https://docs.github.com/en/graphql/reference/pulls

## Issue close and cleanup

- After merge, read linked issues before attempting an explicit close because `Closes #...` / `Resolves #...` may already have closed them.
- Close explicitly only when acceptance criteria are satisfied and the issue remains open.
- Cleanup only worklines proven merged, superseded, abandoned, or created by the current task.
- Never delete unrelated active branches/PRs/issues.
- If branch-deletion capability is not available through the active connector, report it accurately rather than claiming cleanup succeeded.

## Error classification

### Connector/host-side rejection

Treat as an uncertain transport/action result. Perform read-back reconciliation and the single identical retry rule. Do **not** infer authentication expiry or require a user click.

### GitHub API error

Only classify a write as a GitHub-side blocker when GitHub itself returns a concrete API error (for example `401`, `403`, `405`, `409`, or `422`) **and** read-back confirms the intended state was not established.

### Business/engineering blocker

Draft status, failed CI, unresolved review, missing external configuration, target-machine verification, unavailable required evidence, or unmet acceptance criteria are real blockers and must not be bypassed by retries.

## Scheduled-run recovery

Every autonomous GitHub run must begin by looking for a canonical unfinished workline before selecting a new issue. Recovery must include branch-only states, not just open PRs:

- intended branch not yet created;
- branch exists but PR not yet created;
- commit/ref update incomplete;
- PR awaiting CI/review;
- PR ready to merge;
- merge completed but issue/cleanup pending.

The same branch name, head/base pair, and expected SHA are reused across runs. No duplicate workline is created.

## OpenAI-side boundary

OpenAI model guidance distinguishes external writes from ordinary reads/local actions and recommends explicit autonomy/approval boundaries. This protocol does not bypass host safety controls; it makes retries safe and idempotent by reconciling each requested write against the external system's authoritative state.

Primary source: https://developers.openai.com/api/docs/guides/latest-model
