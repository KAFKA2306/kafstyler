---
description: Design a dimensional model from actual questions and an existing source. Use for star schema, star schemes, スタースキーマ, facts, dimensions, and grain.
---

# Star Schema

1. Choose the business process, users' questions, and source owner. State what one fact row means before selecting keys or fields.
2. Define fact keys, event time, measures and their aggregation limits. Define dimensions with business keys, join cardinality, and history behavior needed by the questions.
3. Keep facts of different grains separate. Reuse conformed dimensions where there is a demonstrated common identity. Document unknown keys, late arrivals, and how corrections are reflected.
4. Check source-to-fact totals, unique grain, orphan keys, and a representative query for join fan-out. Map existing data and backfill only the requested history.

Deliver a grain statement, the schema and join keys, and a query with its reconciliation result. Use the Kimball and Microsoft references in [MISSION.md](../MISSION.md).
