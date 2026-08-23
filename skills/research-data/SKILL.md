---
name: research-data
description: Turn research questions and source material into trustworthy, reusable data and evidence-backed results. Use for KAFKA2306 research/data/knowledge repositories outside finance, VR/3D, games, and platform operations.
---

# Research & Data

Produce the smallest trustworthy research artifact that materially improves what can be known, reused, or sold.

## Every run

1. Read the current repository state, canonical data/artifacts, open work, and the primary papers, datasets, standards, or official sources needed for the active question.
2. Continue the existing canonical workline when it is still valuable; otherwise choose the task with the highest expected evidence, reuse, economic, or future-cost value.
3. Prefer direct observations, verified data, reproducible analysis, and reusable artifacts over infrastructure, documentation churn, or speculative features.
4. Make the smallest coherent change. Reuse existing methods and data structures; delete or simplify before adding code, dependencies, schemas, services, or workflows.
5. Verify the actual outcome with the repository's existing checks and persisted artifacts. Verify public output when publication is part of the claim.
6. Report only the material before → after difference, evidence, reusable result, value path, verification state, and next highest-value research problem.

## Evidence

- Prefer original papers, official datasets, standards, government sources, project documentation, official APIs, and canonical repository data.
- Never invent observations, sample sizes, metrics, dates, identifiers, citations, or experimental results.
- Separate observed fact, source claim, derived result, inference, and unknown.
- Preserve identity, units, periods, geography, edition/version, null/unknown semantics, and source precision.
- Do not turn limits, permissions, plans, estimates, or test capacity into observed real-world performance.
- Do not infer more precision than the source supports.
- Keep enough provenance to reproduce why a record or result exists.

## Workflow

Use only the stages justified by the question:

```text
question
→ primary source / raw data
→ provenance
→ validation / deduplication
→ analysis or reproduction
→ persisted reusable artifact
→ checks / evaluation
→ publication or integration when justified
```

Stop when enough evidence exists to support the result. Do not add stages merely to look complete.

## Data

- Keep canonical inputs separate from generated views.
- Reuse established identifiers and schemas; avoid duplicate authorities.
- Deduplicate by real identity, not display-string similarity alone.
- Preserve raw source evidence when required for reproducibility or audit.
- Treat missing and unknown as data, not zero or false.
- Keep observations with incompatible scope or definitions separate.

## Analysis

- Use metrics that directly answer the research question.
- Compare against the relevant baseline, not an easy proxy.
- Report sample size, period, inclusion/exclusion rules, uncertainty, and failure cases when material.
- Reproduce published results only as far as the available data and method permit.
- A green test suite proves only the checks that actually ran on that revision.

## Value

Prefer work that creates at least one of these:

- a reusable dataset, benchmark, model, view, API, or research result;
- a verified correction that prevents downstream error;
- a result that supports a product, service, licensing, distribution, or adoption path;
- automation that removes repeated acquisition, cleaning, validation, or review work;
- a reduction in material uncertainty that changes a real decision.

Do not claim monetization, demand, adoption, or production impact without direct evidence.

## Documentation

Keep repository-specific methodology, provenance, semantics, assumptions, limitations, reproducibility, and publication policy. Prefer delete obsolete docs → merge overlaps → link to one canonical definition → add only when necessary. Do not duplicate papers, standards, schemas, generated results, or source-code behavior in prose.

## Verification

Use the repository's existing toolchain. Verify as applicable:

- raw source → canonical data;
- provenance and hashes;
- identity, deduplication, units, and periods;
- deterministic rebuild or reproduction;
- analysis outputs against source data;
- exact revision checks;
- main-branch read-back after integration;
- public artifact or API after publication.

Unobserved empirical, field, production, or public-runtime claims remain UNVERIFIED.

## Decision rule

Prefer the task that produces more trustworthy reusable evidence with less new complexity and less future manual work.
