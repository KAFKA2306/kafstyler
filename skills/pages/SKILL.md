---
name: pages
description: Design and improve public web pages around what visitors actually want to understand or do. Use for GitHub Pages, dashboards, explainers, data products, landing pages, and other public web surfaces.
---

# Pages

The page is the product, not a window into its engineering process.

A visitor should understand the subject itself and complete the intended task without knowing the repository, implementation, CI, deployment, commits, or development history.

## Every run

1. Identify the visitor and the one main question or task that brought them here.
2. Open the live page and inspect the real content/data it represents.
3. Find the largest obstacle to understanding or action.
4. Make the smallest coherent improvement to content, hierarchy, interaction, or presentation.
5. Verify the public user journey on the live page when deployment is part of the task.

## What the page should show

Lead with the subject matter.

- What is this?
- What is important now?
- What should I notice, compare, decide, or do?
- What context is necessary to understand it?
- Where can I verify an important claim?

Use history or change only when it is history or change in the subject the visitor cares about. Do not surface engineering history as user content.

## Keep engineering behind the page

Repository state, commits, PRs, CI, deployment IDs, implementation notes, test evidence, framework choices, and refactoring history are internal verification material unless the page itself is explicitly about software operations.

Use those internally to make the page trustworthy. Do not make visitors read them.

## Standalone presentation

Make the public page read naturally to a first-time visitor who has never seen the conversation or production process behind it.

- Remove conversational residue, revision notes, instruction references, and other production meta.
- Do not let examples used during planning leak into the page unless they actually belong to the subject.
- Remove patchwork from repeated edits; keep voice, terminology, assumptions, and visual language consistent.
- Encode constraints in the design and wording instead of explaining the constraints to visitors.
- Keep necessary context, technical accuracy, interpretation guidance, and safety information.

## Information design

- Give the strongest visual emphasis to the most important user-facing information.
- Prefer a clear narrative and visual hierarchy over a collection of equal cards.
- Put explanation next to the thing it explains.
- Use charts, maps, tables, images, or interaction only when they make the subject easier to understand.
- Make important comparisons visually immediate.
- Keep labels and language concrete; remove internal jargon that visitors do not need.
- Reveal detail progressively instead of showing everything at once.
- Preserve useful state in URLs when sharing or returning to a view matters.

## Evidence and data

- Use canonical data and primary evidence where available.
- Separate observed facts from estimates, forecasts, plans, marketing claims, and interpretation.
- Show source, scope, unit, definition, and as-of information where they affect meaning.
- Never turn missing, unknown, stale, or unverified data into zero or current data.
- Do not create a second manually maintained truth just for the page.

## Web quality

- Prefer semantic HTML and native browser behavior.
- Make mobile, keyboard, focus, contrast, touch targets, loading, empty, error, and reduced-motion states work.
- Prefer fewer dependencies, less JavaScript, and simpler layouts when they deliver the same result.
- Avoid decorative dashboard clutter, repeated cards, gratuitous gradients, animation, and generic AI-looking composition.

## Decision rule

Prefer the change that lets a first-time visitor understand the subject or complete the task sooner, with less ambiguity and less interface.

If a change mainly explains how the page was built rather than what the visitor came to learn or do, do not put it on the page.

## Done

Done means the intended visitor can use the public page successfully and the important information is correct and understandable.

Implementation, merge, CI, and deployment are means of verification, not the user-facing outcome.
