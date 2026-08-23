---
name: finance
description: Turn finance questions, market data, research ideas, and repository work into verified evidence and decisions. Use for financial research, datasets, models, backtests, portfolio analysis, finance repositories, and finance-wide routing.
---

# Finance

Turn a finance question into a decision supported by current, reproducible evidence.

## Every run

1. State the decision or claim being tested.
2. Read the current primary source, canonical dataset/repository, relevant code, and latest output before reasoning from old context.
3. Use one canonical authority per fact, dataset, or model output. Reuse the owning repository instead of creating a duplicate collector, ledger, cache, or view.
4. Measure the thing that matters directly. Do not treat implementation, CI, a proxy metric, or a model score as economic evidence when P&L, risk, coverage, freshness, or another direct outcome can be measured.
5. Test with real data when available. Record the universe, period, point-in-time rules, benchmark, costs, assumptions, and exact revision.
6. Compare against a simple baseline or ablation. For strategies, prefer out-of-sample or walk-forward evidence and include transaction costs and borrowing costs when relevant.
7. Decide from the measured result: keep, reject, revise, or unknown. Never fill missing evidence with a financial claim.
8. Verify the final repository/data/public state. Merge and release are separate; green CI alone is not release evidence.

## Evidence rules

Prefer, in order:

1. official filings, exchanges, regulators, central banks, statistical agencies, issuer IR, and official APIs;
2. canonical raw snapshots with provenance and hashes;
3. reproducible normalized/derived data;
4. secondary sources only when primary evidence is unavailable or for context.

Keep observed fact, estimate, guidance, forecast, hypothesis, and interpretation separate.

Preserve source URL, observation/effective date, retrieval time, unit, scope, entity identity, and revision/hash when they affect reproducibility.

Do not convert missing, stale, unavailable, or unverified data into zero or current values.

## Strategy and model validation

Implementation is not validation.

For empirical investment claims, report the direct outcomes that matter, as applicable:

- universe and selection rule;
- train / validation / OOS periods;
- point-in-time and survivorship controls;
- cumulative and annualized return;
- Sharpe or another declared risk-adjusted metric;
- maximum drawdown;
- benchmark beta/correlation when relevant;
- turnover, gross/net exposure, and concentration;
- transaction, spread, slippage, and borrow assumptions;
- baseline or ablation comparison;
- sensitivity to important choices such as universe size, costs, dates, or seed.

A larger universe is not automatically better. If universe size could explain the result, test it directly rather than speculate.

Do not describe a strategy as validated when the measured OOS result rejects it. A negative result that cleanly rejects a hypothesis is a completed experiment.

## Repository ownership

Source-data semantics belong to the repository that owns that domain. `investor2` may integrate evidence and decisions across domains, but should not become a duplicate source authority.

Shared storage, cache, authentication, or transport infrastructure must stay generic. Do not move dataset-specific freshness, validation, or release authority into an unrelated repository merely because it holds credentials or storage access.

Delete superseded collectors, fallbacks, compatibility paths, duplicated outputs, stale workflows, and obsolete docs once the canonical replacement is verified. Preserve historical reproducibility through Git history and immutable evidence, not live legacy paths.

When a repository has a dedicated Repo Agent, leave ordinary implementation there. Cross-repository routing should resolve ownership, duplication, dependency, and release boundaries rather than duplicate the implementation workline.

## Merge and release

A bounded repository change may merge when the reviewed revision is correct, deterministic checks pass, and its data/model/provenance contract is preserved.

Release is complete only when the merged revision and the real output surface are directly verified. For data, read back the published artifact/manifest and verify identity/hash/freshness as applicable. For public views, verify the deployed page. For research, verify the persisted empirical artifact and recompute the reported result when practical.

Never infer `released` from `merged`, and never mark a correct merged implementation as failed only because a later live-source condition is blocked.

## Safety

Never execute trades, transfers, borrowing, account changes, or credential changes unless the user explicitly requests an allowed action through an appropriate authorized tool.

Never invent prices, returns, holdings, financial statements, source observations, or market events.

## Report

Keep the final answer decision-oriented:

- what was tested or changed;
- the strongest current evidence;
- the measured economic result;
- what remains unknown or blocked;
- the canonical owner of the next action.

Use plots and tables when they make the measured result easier to judge, not as decoration.
