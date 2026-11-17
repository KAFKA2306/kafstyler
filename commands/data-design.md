---
description: Design data from entities, ontology, metadata, ledgers, masters, star schemas, and dbt. Use for メタデータ, 台帳, ledger, masters, ontology, or schema design.
---

# Data Design

1. Identify the question or action, existing source owner, and real inputs. Define each entity's stable identity, relationships, and valid actions. Use IOF terms for industrial concepts and Foundry patterns for operational object models where relevant.
2. Specify fields needed for retrieval, decisions, or verification. Include source ID and URL, time, schema version, units, null semantics, and provenance as relevant.
3. For a ledger, give one row a stable key, define accepted status changes and correction history, and reconcile repeated inputs. For a master, define the entity key, authoritative attributes, and validity periods when needed.
4. For analytics, declare what one fact row measures before designing dimensions. Keep grains distinct and check fan-out, orphan keys, and totals after joins.
5. Where dbt is already the transformation layer, declare canonical input through `source()`, connect models with `ref()`, and use relevant uniqueness, relationship, and reconciliation checks. Trace derived outputs back to their sources.

Deliver the applicable contract and a read-back using a real record or query.

## References

- [Industrial Ontologies Foundry・IOF Ontology Portal](../MISSION.md#canon-iof-ontology)
- [Palantir Foundry・Ontology](../MISSION.md#canon-foundry-ontology)
- [Palantir Foundry・Data Lineage](../MISSION.md#canon-foundry-data-lineage)
- [Microsoft Learn・スター・スキーマ](../MISSION.md#canon-microsoft-star-schema)
- [Kimball Group・ファクトの粒度](../MISSION.md#canon-kimball-grain)
- [W3C・PROV-O 来歴の標準](../MISSION.md#canon-w3c-prov-o)
- [W3C・DCAT 3 データカタログの標準](../MISSION.md#canon-w3c-dcat)
- [dbt Developer Hub・dbtの概要](../MISSION.md#canon-dbt-introduction)
- [dbt・ソースと来歴](../MISSION.md#canon-dbt-sources)
- [dbt・データ品質テスト](../MISSION.md#canon-dbt-data-tests)
- [Pydantic・検証の公式ドキュメント](../MISSION.md#canon-pydantic)
- [かふかのZenn記事一覧](../MISSION.md#canon-kafka-zenn)
