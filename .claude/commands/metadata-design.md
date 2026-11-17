---
description: Design useful metadata, provenance, or an object model for datasets, assets, workflows, and publications. Use for メタデータ, 来歴, schema, ontology, or catalog design.
---

# Metadata Design

1. List what people or tools need to find, compare, reuse, validate, or trace. Derive each required field from one of those operations.
2. Identify object types, identities, relationships, and valid actions. Consult IOF for industrial concepts and Foundry when designing an operational object model.
3. Keep source identity and URL, event or retrieval time, format/schema/revision, license and publication state when relevant. Attach hashes to exact artifacts when integrity or reproducibility depends on them. Record units and null semantics for measured data.
4. Keep observed, inferred, generated, missing, and current states distinct. Draw the lineage from primary inputs to canonical records to derived outputs. Use an existing schema or Pydantic at input boundaries where required.
5. Try one real artifact and one incomplete or conflicting record. Verify lookup, source trace, required-field behavior, and equivalence against the baseline when making comparative claims.

Deliver the field dictionary, a real sample, provenance, and the validation result. Consult [MISSION.md](../../MISSION.md) for IOF, Foundry, W3C, and tool documentation.
