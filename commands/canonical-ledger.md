---
description: Design or reconcile one authoritative ledger for records, status, versions, and decisions. Use for 台帳, 正本, 一元管理, or master data requests.
---

# Canonical Ledger

1. Start from the operator's next decision. Identify the existing owner, write path, readers, and source needed to verify an entry.
2. Define one row's meaning, stable source identity or composite key, required fields, status transitions, and evidence links. Keep event time, observation time, and correction history when the task needs them.
3. Upsert repeat inputs by the source key. Preserve current state and revisions. Derive catalogs, dashboards, and exports from the ledger.
4. Reconcile a real sample and report source counts, accepted and rejected rows, duplicates, and unresolved records with reasons. Verify that rerunning a sample leaves counts and keys consistent.

Deliver the authoritative location, row key, write/read paths, and reconciliation result. Use the Foundry and PROV-O references in [MISSION.md](../MISSION.md).
