---
name: finance
description: Use when a finance task must end in a decision. Convert a market, research, data, model, or repository question into current reproducible evidence and a clear keep, reject, revise, or unknown decision.
---

# Finance

## Problem this skill solves

Finance work often stops at **data collected**, **model built**, or **CI passed**. Those are intermediate states, not answers.

This skill exists to answer one question:

**What should we believe or decide, given the best current evidence?**

## Workflow

1. **Define the decision.** State the claim or choice in one sentence. Make it falsifiable when possible.
2. **Find the authority.** Read the current primary source and canonical dataset/repository/output. Keep one authority per fact, dataset, or model result.
3. **Measure directly.** Use real data when available. Record the universe, period, point-in-time rules, benchmark, costs, assumptions, and exact revision.
4. **Challenge the result.** Compare against a simple baseline or ablation. Prefer OOS or walk-forward evidence. Test important alternative explanations instead of speculating.
5. **Decide.** Return **keep**, **reject**, **revise**, or **unknown** from measured evidence. Missing evidence stays unknown.
6. **Verify the delivered state.** Read back the persisted artifact, dataset, model output, or public surface. Merge and release are separate.

## Investment and model claims

Implementation is not validation.

When relevant, report:

- universe and selection rule;
- train / validation / OOS periods;
- point-in-time and survivorship controls;
- cumulative or annualized return;
- Sharpe or another declared risk-adjusted metric;
- maximum drawdown;
- benchmark beta or correlation;
- turnover, gross/net exposure, and concentration;
- transaction, spread, slippage, and borrow assumptions;
- baseline or ablation comparison;
- sensitivity to choices that could explain the result.

If universe size could explain the outcome, test universe size directly. If costs could explain it, sweep costs. If a negative OOS result rejects the hypothesis cleanly, the experiment is complete.

## Evidence

Prefer official filings, exchanges, regulators, central banks, statistical agencies, issuer IR, and official APIs. Then use canonical raw snapshots with provenance, reproducible derived data, and only then secondary sources for context.

Keep observed facts, estimates, guidance, forecasts, hypotheses, and interpretation separate. Never turn missing, stale, unavailable, or unverified data into a current financial fact.

## Repository boundary

Source-data semantics belong to the repository that owns the domain. `investor2` integrates evidence and decisions across domains; it should not duplicate source authority.

Shared storage, authentication, cache, and transport must remain generic. Dataset-specific collection, validation, freshness, and release decisions stay with the dataset owner.

When a repository has a dedicated Repo Agent, leave ordinary implementation there. Cross-repository work should resolve ownership, duplication, dependencies, and release boundaries.

Delete superseded collectors, fallbacks, compatibility paths, duplicate outputs, stale workflows, and obsolete docs after the canonical replacement is verified.

## Safety

Never invent prices, returns, holdings, financial statements, or market events. Never execute trades, transfers, borrowing, or account changes unless explicitly requested through an appropriate authorized tool.

## Output

Lead with the decision, then show the strongest evidence, measured economic result, remaining uncertainty, and canonical owner of the next action. Use a plot or table when it makes the result easier to judge.
