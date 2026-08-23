---
name: vr-3d
description: Build and improve VR, 3D, and spatial assets, tools, and experiences for durable reuse, distribution, and revenue. Use for Unity, Blender, VRChat, photogrammetry, Gaussian Splatting, avatars, worlds, spatial web, asset pipelines, and related marketplaces.
---

# VR / 3D

Turn spatial work into usable, reusable, distributable assets and experiences with verifiable evidence.

## Workflow

1. Read the current repository, canonical PR/Issue, manifests, artifacts, runtime state, and relevant official platform or upstream documentation.
2. Choose the single capability or blocker with the highest expected impact on sales, adoption, conversion, reusable asset value, or production cost.
3. Complete one coherent workline. Reuse upstream importers, renderers, SDKs, formats, packages, and distribution paths before adding custom tooling.
4. Preserve provenance, licenses, content identity, tool versions, and artifact lineage.
5. Verify the strongest available outcome: artifact integrity, import/build, runtime/device/client behavior, deployment, marketplace, or public distribution.
6. Report only the observable before → after result, artifact, monetization/distribution path when grounded, evidence, PR/CI/merge/public state, and next highest-value VR/3D problem.

## Rules

- Keep one canonical registry or manifest. Derive collection size, layout, validation, and generated outputs from it; do not hard-code target asset counts for modular collections.
- Give reusable assets stable identity, source/provenance, license state, content hash when practical, production artifact reference, and consumer evidence.
- Keep source truth separate from generated derivatives. Do not duplicate catalogs, license databases, provenance, binaries, or playback metadata without a demonstrated need.
- Keep large generated artifacts out of normal Git history when an existing artifact store or materialization path is more appropriate.
- Treat Blender, Unity, browser, VRChat PC, VRChat Android, marketplaces, and other consumers as independent targets. PASS does not propagate between them.
- Prefer one production renderer, importer, package path, and artifact authority per responsibility.
- Separate reusable asset normalization from scene-specific presentation.
- Measure real constraints when they matter: bounds, scale, build size, memory, frame time, compatibility, references, package versions, and device behavior.
- Do not hide performance failures by silently removing required user value. Keep unknown, blocked, and unverified states explicit.
- Do not fabricate uploads, purchases, marketplace approvals, runtime observations, credentials, publication, sales, or adoption.
- Prefer the shortest path toward real use: usable artifact → reliable consumer path → demonstrable experience → distribution/sales → measured use or revenue.
- Delete superseded code, metadata, docs, fixed-cardinality assumptions, and workflows when replacing them safely.

## Done

Completion requires evidence at the level of the intended outcome. Code, PR, merge, or CI alone is not completion when the intended artifact, consumer, runtime, or distribution surface has not been verified.

Use current official Unity, Blender, VRChat, package, license, marketplace, and upstream documentation for platform-specific detail instead of expanding this Skill with local rules.
