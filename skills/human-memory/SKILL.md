---
name: human-memory
description: Build, audit, migrate, and verify human-memory systems from raw evidence to reviewed memory, rebuildable narrative artifacts, and explicitly approved public projections. Use for VLog, memory repositories, ingestion, provenance, retrieval, privacy, migration, and publication.
---

# Human Memory

Keep memory useful, traceable, private by default, and reconstructable.

## Every run

1. State the human outcome or invariant being improved.
2. Read the current owning repository, schemas, source evidence, storage/runtime state, and relevant Issue/PR before relying on old context.
3. Classify affected data as Evidence, Human Memory, Narrative Artifact, or Public Projection.
4. Fix the single highest-value broken invariant with the smallest coherent change. Reuse or delete before adding another store, abstraction, workflow, or compatibility path.
5. Verify the affected real path directly: ingest, read back, query, regenerate, reconcile, or inspect the public projection as applicable.
6. Report the observable before → after result and what remains unverified.

## Canonical model

```text
Evidence -> Human Memory -> Narrative Artifact -> Public Projection
```

- **Evidence** is source material and provenance. Keep raw/private evidence out of public repositories and public-by-default storage.
- **Human Memory** is reviewed canonical meaning: episodes, claims, revisions, relationships, preferences, decisions, and open loops.
- **Narrative Artifact** is derived output such as summaries, diaries, novels, images, graphs, embeddings, or indexes. It must be rebuildable.
- **Public Projection** contains only information explicitly approved for publication.

Do not promote a generated artifact, search index, graph, vector store, ChatGPT memory, or convenience cache into a second canonical truth.

## Integrity rules

- Accepted claims require provenance back to evidence.
- Corrections create revisions; do not silently overwrite history.
- Use stable identity, content hashes, pipeline versions, and idempotency where repeated ingestion can occur.
- Keep observation, inference, generation, review, and publication status distinct.
- Retrieve mutable current state from its owner instead of copying snapshots into durable instructions or memory.
- Keep current runtime and target architecture separate; planned state is not implemented state.

## Migration and privacy

- Preserve evidence, canonical migration history, and reproducibility records.
- Destructive deletion or relocation requires retained backup plus complete reconciliation of affected sources and outputs.
- Compatibility shims are temporary. Remove them after the canonical replacement is verified and reconciliation is complete.
- Enforce private/public boundaries in canonical storage and policy where possible, not only in UI or application convention.
- Never convert missing, partial, stale, or unverified state into a successful migration or remembered fact.

## Decision rule

Prefer the option with more provenance, fewer canonical copies, less irreversible change, less maintenance, and stronger direct verification.

## Done

Completion requires evidence for the intended outcome, not merely code, a PR, merge, or green CI. Depending on the change, prove that repeated ingestion does not duplicate records, claims trace to evidence, revisions survive correction, private data stays private, derived artifacts can be rebuilt, or the intended public projection is actually correct.

A repository-only change does not prove a live storage, database, deployment, or environment cutover.
