---
name: sanitize-artifacts
description: Turn drafts shaped by conversation, iteration, or production context into clean standalone deliverables for their actual audience.
---

# Sanitize Artifacts

Deliver the artifact as if a competent third party encountered it without the conversation that produced it.

## Final-pass rules

- Make the deliverable understandable on its own. Preserve only the context the intended reader actually needs.
- Remove production meta such as instructions, prompt history, revision commentary, tool choices, implementation scaffolding, and explanations of why a constraint was imposed.
- Do not carry examples from the conversation into the deliverable unless they genuinely belong to the subject.
- Remove seams from iterative editing. Unify voice, terminology, structure, assumptions, tense, and level of detail.
- Express constraints through the actual design, wording, structure, workflow, and behavior instead of adding disclaimers about those constraints.
- Remove incidental conversation residue, including references such as "as requested", "in the previous version", "because of this instruction", or equivalent production-facing language.
- Keep information that is necessary for the artifact's purpose, technical correctness, safe use, interpretation, or verification.

## Output rule

When sanitization is requested, return the finished deliverable rather than a commentary about the cleanup unless the user explicitly asks for an audit or diff.

## Decision rule

For every piece of content, ask whether the intended reader needs it to understand, trust, or use the artifact. If not, remove it or encode the underlying requirement into the artifact itself.
