---
name: pages
description: Improve GitHub Pages and other public static web surfaces simply and effectively. Use for page design, information hierarchy, dashboards, accessibility, responsive behavior, performance, and production verification.
---

# Pages

Build a public page that communicates the most important verified information quickly, clearly, and reliably.

## Every run

1. Read the current repository, canonical data/API, current Pages implementation, and live production page before changing anything.
2. Identify the single highest-value user-facing weakness. Prefer direct user outcomes over internal cleanup.
3. Make the smallest coherent change that materially improves understanding, navigation, trust, accessibility, or speed.
4. Prefer deleting, simplifying, or reusing existing code before adding components, dependencies, frameworks, services, or duplicate data.
5. Verify the actual result. Run the repository's existing checks, then verify the deployed production surface when deployment is part of the task.
6. Report the observable before → after difference. Do not call implementation or CI success alone "done".

## Page hierarchy

The first viewport should answer the page's primary user question without requiring README knowledge.

Prefer this order when relevant:

1. **What matters now** — the latest verified fact, state, result, or decision.
2. **What changed** — a meaningful comparison, not a forced daily delta.
3. **Why it matters** — interpretation clearly separated from observed fact.
4. **History / context** — enough trend or comparison to judge whether the current state is unusual.
5. **Evidence** — as-of time, source, definition, uncertainty, and a direct path to primary evidence.
6. **Explore** — search, filters, tables, maps, API, methodology, and developer details below the main answer.

If nothing changed, say so. Never manufacture activity to make a dashboard look current.

## Data rules

- Render canonical repository data or APIs. Do not create a second manually maintained truth for Pages.
- Keep observed facts separate from forecasts, plans, estimates, guidance, interpretation, and marketing claims.
- Preserve units, dates, scope, geography, definitions, and provenance.
- Do not convert missing, unknown, stale, or unverified values into zero or current values.
- Do not compare values whose definitions or scopes are incompatible.
- Show source and as-of information close enough to the claim that users can judge it.

## Design rules

- Establish one clear visual hierarchy. Do not give every block equal weight.
- Prefer strong typography, spacing, alignment, and grouping over decorative cards and effects.
- Use color as support, never as the only carrier of meaning.
- Keep motion restrained and functional.
- Avoid generic AI-dashboard clutter, repeated badges, unnecessary gradients, and ornamental charts.
- Use charts only when they make a comparison or trend easier to understand than text or a table.
- Keep copy short, concrete, and domain-specific.

## Web quality

- Use semantic HTML and native controls where practical.
- Preserve keyboard navigation, visible focus, readable contrast, touch targets, and reduced-motion behavior.
- Verify narrow mobile layouts and zoom/reflow; avoid page-level horizontal overflow.
- Design loading, empty, partial, stale, and error states explicitly.
- Keep JavaScript and dependencies minimal. Static HTML/CSS/JS is preferred when it solves the problem well.
- Do not add a frontend framework, analytics service, backend, or design system without a demonstrated need.
- Protect performance: avoid unnecessary client work, large assets, layout shift, and render-blocking additions.

## Improvement rule

Each run should leave the page simpler or more useful than before.

When choosing between alternatives, prefer the one that:

1. answers the user's primary question sooner;
2. uses more direct evidence;
3. removes more ambiguity;
4. requires less code and maintenance;
5. is easier to verify in production.

Do not accumulate old layouts, duplicate components, compatibility paths, stale text, or abandoned experiments.

## Verification

Use the repository's existing toolchain and checks rather than inventing a parallel test stack.

For public Pages work, verify as applicable:

- canonical input → generated/public output;
- exact source revision deployed;
- primary journey in a real browser;
- mobile / keyboard / focus / zoom-reflow behavior;
- loading / empty / error / stale states;
- source links and provenance;
- production URL after deployment.

A local render, merged PR, or green CI is not production verification.

## References

Use established upstream guidance when deeper design review is useful rather than inventing local terminology:

- Anthropic `frontend-design`: https://github.com/anthropics/skills/tree/main/skills/frontend-design
- OpenAI `frontend-skill`: https://github.com/openai/skills/tree/main/skills/.curated/frontend-skill
- Vercel `web-design-guidelines`: https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines
- GOV.UK Service Standard: https://www.gov.uk/service-manual/service-standard
- W3C WCAG: https://www.w3.org/WAI/standards-guidelines/wcag/

These are references, not additional mandatory layers. Keep the repository-specific implementation as small as possible.
