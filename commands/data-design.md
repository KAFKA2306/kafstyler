---
description: Design data from entities, ontology, metadata, ledgers, masters, star schemas, and dbt. Use for メタデータ, 台帳, ledger, masters, ontology, or schema design.
---

# Data Design

1. Identify the question or action, existing source owner, and real inputs. Define each entity's stable identity, relationships, and valid actions. Use IOF terms for industrial concepts and Foundry patterns for operational object models where relevant.
2. Specify fields needed for retrieval, decisions, or verification. Include source ID and URL, time, schema version, units, null semantics, and provenance as relevant.
3. For a ledger, give one row a stable key, define accepted status changes and correction history, and reconcile repeated inputs. For a master, define the entity key, authoritative attributes, and validity periods when needed.
4. For analytics, declare what one fact row measures before designing dimensions. Keep grains distinct and check fan-out, orphan keys, and totals after joins.
5. Where dbt is already the transformation layer, declare canonical input through `source()`, connect models with `ref()`, and use relevant uniqueness, relationship, and reconciliation checks. Trace derived outputs back to their sources.

Deliver the applicable contract and a read-back using a real record or query. Use the IOF, Foundry, Kimball, W3C, and dbt references in [MISSION.md](../MISSION.md).
