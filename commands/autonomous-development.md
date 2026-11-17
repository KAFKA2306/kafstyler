---
description: Carry an authorized change through implementation, verification, and delivery. Use for 自律開発, 実装して, やり切る, or workflow simplification.
---

# Autonomous Development

1. Read the owning project's current state, ordinary entry point, and acceptance check. Use the existing issue or PR to carry the work. If the goal is unclear, establish it first with `outcome-design`.
2. Inspect the actual obstacle. Remove dead paths or duplicate responsibilities, reuse existing standard tools and official APIs, and make the smallest coherent change. For frontend design, invoke `demolab:gemini-frontend-design` when available. Follow the owning project's design system and use the [official DemoLab guidance](https://github.com/google-gemini/demolab#claude-code) to load the skill for UI work. Reuse existing verification. Add a workflow, CI job, test, script, or hook only if it catches a concrete failure or eliminates demonstrated repeat work. During cleanup, remove duplicate gates and measure the reduction.
3. For ComfyUI work, open the [official Workflow Templates](https://github.com/Comfy-Org/workflow_templates) through Workflow → Browse Workflow Templates. Start with the matching template, record its upstream revision and required models, and verify a real output in the owning runtime.
4. Run the narrow checks that can catch the relevant failure, then verify the ordinary user operation on the actual revision or target. Compare counts or effort if the request is simplification.
5. Use the project's normal delivery path. For GitHub work, review the diff, complete authorized PR and merge work, confirm main, and clean up the finished branch.

Deliver the working change, concrete evidence, and the next action only when a real blocker remains.
