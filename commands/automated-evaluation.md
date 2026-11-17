---
description: Measure a baseline and candidate with reproducible cases and explicit pass conditions. Use for 自動評価, evals, regression evaluation, or grading.
---

# Automated Evaluation

1. Define the artifact or behavior, consequential failure modes, and pass thresholds before running. Include representative normal, boundary, and previously failing cases from the existing system.
2. Pin inputs and versions. Evaluate the baseline and candidate through the same path with equal budgets and settings.
3. Use deterministic checks for observable outcomes. For judgment calls, use a concrete rubric and check the grader against existing labeled examples where available. Repeat stochastic trials enough to show relevant spread.
4. Report per-case results, aggregate change, cost or duration when relevant, failure reasons, and the reproduction command or source. Treat missing measurements as unverified.

## References

- [Anthropic・成功基準と評価の設計](../MISSION.md#canon-anthropic-evaluation)
- [dbt・データ品質テスト](../MISSION.md#canon-dbt-data-tests)
- [かふかのZenn記事一覧](../MISSION.md#canon-kafka-zenn)
