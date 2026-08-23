---
name: games
description: Build, audit, and improve game and board-game products with rule correctness, player value, revenue awareness, and production evidence. Use for game repositories, rule data, discovery, game pages, tooling, monetization, migrations, and operations.
---

# Games

Make the game product more correct, useful, and valuable to players.

## Every run

1. Read the current repository, active workline, CI/deployment/production state, usage or conversion evidence, and official sources needed for the task.
2. Define one observable player-facing success condition before changing anything.
3. Choose the highest-value problem by expected impact on discovery, setup/play clarity, trust, retention, monetization, or operating cost.
4. Identify the exact game, product, edition, language, and rules revision before changing rules. If identity is uncertain, fix or block it; never guess.
5. Treat first-party publisher/designer rules as authority. Keep official facts separate from summaries, interpretation, variants, expansions, digital implementations, and tournament overrides.
6. Prefer one canonical data and runtime path. Delete, simplify, or reuse before adding compatibility paths, one-off scripts, duplicate truth stores, or title-specific infrastructure.
7. Make the smallest coherent change that satisfies the player-facing condition.
8. Verify with the repository's existing checks, exact revision, production/public surface, and the real player journey. Implementation, merge, or green CI alone is not done.
9. Report only the observable Before → After outcome, trusted evidence, grounded monetization path, PR/CI/merge/production state, removed duplication/manual work, and next highest-value game problem.

## Rules

- Prefer direct evidence over proxy metrics. Use real usage or conversion data when available; never invent revenue impact.
- Missing, stale, unknown, and unverified values must remain distinct from zero, current, and verified values.
- A stored rule record is not success by itself; the player-facing rule view must be usable and source-backed.
- Preserve edition and revision boundaries. Never silently mix old/new editions, expansions, variants, digital rules, or tournament rules.
- Canonical games must not fall back to stale legacy content after render, hydration, migration, or deployment.
- Keep legacy fallback only while a canonical replacement is incomplete, then remove it.
- If primary evidence is insufficient, move to the next viable high-value target instead of fabricating certainty.
- Continue one canonical Issue/PR when appropriate rather than creating parallel worklines.

## Done

Done means the player-facing success condition is observable on the relevant production or public surface and is supported by current evidence.
