---
description: Carry an authorized change through implementation, verification, and delivery. Use for 自律開発, 実装して, やり切る, or workflow simplification.
---

# Autonomous Development

1. Read the owning project's current state, ordinary entry point, and acceptance check. Use the existing issue or PR to carry the work. If the goal is unclear, establish it first with `outcome-design`.
2. Inspect the actual obstacle. Remove dead paths or duplicate responsibilities, reuse existing standard tools and official APIs, and make the smallest coherent change. For frontend design, invoke `demolab:gemini-frontend-design` when available. Follow the owning project's design system and use the [official DemoLab guidance](https://github.com/google-gemini/demolab#claude-code) to load the skill for UI work. When an upstream tool or skill performs better on real inputs and has credible maintenance and quality checks, replace owned code with it. Verify the normal entry point and retire the replaced implementation. Reuse existing verification. Add a workflow, CI job, test, script, or hook only if it catches a concrete failure or eliminates demonstrated repeat work. During cleanup, remove duplicate gates and measure the reduction.
3. For ComfyUI work, open the [official Workflow Templates](https://github.com/Comfy-Org/workflow_templates) through Workflow → Browse Workflow Templates. Start with the matching template, record its upstream revision and required models, and verify a real output in the owning runtime.
4. Run the narrow checks that can catch the relevant failure, then verify the ordinary user operation on the actual revision or target. Compare counts or effort if the request is simplification.
5. Use the project's normal delivery path. For GitHub work, review the diff, complete authorized PR and merge work, confirm main, and clean up the finished branch.

Deliver the working change, concrete evidence, and the next action only when a real blocker remains.

## References

- [Anthropic・Agent Skills執筆ガイド](../MISSION.md#canon-anthropic-skill-authoring)
- [Anthropic・Claude Code Skills](../MISSION.md#canon-claude-code-skills)
- [Anthropic・Claude Codeプラグインの作成](../MISSION.md#canon-claude-plugin-creation)
- [Anthropic・プラグインの構成要素](../MISSION.md#canon-claude-plugin-components)
- [Anthropic・プラグインマニフェスト仕様](../MISSION.md#canon-claude-plugin-manifest)
- [Anthropic・Claude Codeの実践ガイド](../MISSION.md#canon-claude-code-practices)
- [Pydantic・検証の公式ドキュメント](../MISSION.md#canon-pydantic)
- [Astral・uv](../MISSION.md#canon-astral-uv)
- [Astral・Ruff](../MISSION.md#canon-astral-ruff)
- [Astral・ty](../MISSION.md#canon-astral-ty)
- [Google Gemini・DemoLabのフロントエンド設計スキル](../MISSION.md#canon-google-demolab)
- [ComfyUI・公式ドキュメント](../MISSION.md#canon-comfyui-docs)
- [ComfyUI・Workflow Templatesの使い方](../MISSION.md#canon-comfyui-workflow-templates)
- [ComfyUI・公式テンプレートの正本](../MISSION.md#canon-comfyui-template-source)
- [ComfyUI・Workflow JSON仕様原本](../MISSION.md#canon-comfyui-workflow-json)
- [Pulumi・Infrastructure as Code](../MISSION.md#canon-pulumi-iac)
- [Pulumi・変更の事前確認（pulumi preview）](../MISSION.md#canon-pulumi-preview)
- [かふかのZenn記事一覧](../MISSION.md#canon-kafka-zenn)
