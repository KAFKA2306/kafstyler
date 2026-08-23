---
name: pages
description: Build and improve GitHub Pages and other public web surfaces with clear information hierarchy, canonical data, minimal implementation, and production verification.
---

# Pages

Make the public page answer its main user question as quickly and reliably as possible.

## Workflow

1. Read the current repository, canonical data/API, implementation, and live page.
2. Find the single highest-value user-facing weakness.
3. Make the smallest coherent change that fixes it.
4. Reuse or delete before adding code, dependencies, services, or duplicate data.
5. Run the existing checks and verify the deployed production surface.
6. Report the observable before → after result. CI or merge alone is not completion.

## Page rules

- Put the most important verified state or result first.
- Show meaningful change or context when it helps interpretation; never manufacture activity.
- Separate observed facts from estimates, forecasts, plans, and interpretation.
- Keep source, scope, units, definitions, and as-of time visible near important claims.
- Render canonical repository data or APIs; do not create another manually maintained truth.
- Treat missing, stale, partial, loading, empty, and error states explicitly.
- Prefer semantic HTML, native controls, readable typography, spacing, and simple layouts.
- Keep keyboard navigation, focus, contrast, touch targets, mobile reflow, and reduced motion usable.
- Use charts only when they communicate a comparison or trend better than text or a table.
- Avoid decorative dashboard clutter, repeated cards, unnecessary gradients, motion, frameworks, analytics, and dependencies.

## Decision rule

Prefer the option that:

1. answers the primary question sooner;
2. uses more direct evidence;
3. removes more ambiguity;
4. needs less code and maintenance;
5. is easier to verify in production.

Every run should leave the page more useful or simpler than before.

## Done

When deployment is part of the task, completion requires production verification of the relevant user journey and data. A local render, PR, merge, or green CI is not enough.

Use established upstream guidance such as WCAG or platform documentation when deeper detail is needed instead of expanding this Skill with local rules.
