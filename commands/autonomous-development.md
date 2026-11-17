---
description: "許可された変更を実装し、実際の利用経路で確かめて届ける。自律開発、実装、作業手順の簡素化に使う。"
---

# 自律開発

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../CANON.md#canon-humanizer-ja)を適用する。[出力の共通基準](../MISSION.md#mission-output-style)

1. プロジェクトの現状、利用者が使う入口、合格条件を確認する。目標が曖昧なら[目標設定](outcome-design.md)を使う。進行中のIssueやPRがあればその作業を引き継ぐ。
2. 実際の障害を確認し、役割を終えた経路や重複を除く。標準の道具と公式APIを使い、依頼に必要な変更単位を選ぶ。フロントエンドでは、プロジェクトのデザイン規則に従い、利用できる場合は `demolab:gemini-frontend-design` を使う。[DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)
3. 手法を置き換える場合は、現行と外部候補を同じ入力で[自動評価](automated-evaluation.md)する。合格条件を満たし、品質や運用工数が改善し、保守と検証の根拠がある候補を採用する。通常の入口から確認した後に[旧実装を整理する](remove-ai-slop.md)。
4. ComfyUIでは `Workflow → Browse Workflow Templates` から[公式テンプレート](https://github.com/Comfy-Org/workflow_templates)を選び、元の版と必要モデルを記録する。実際の環境で出力を確かめる。[Unity・VRChat制作](../CANON.md#unity-vrchat-tools)では用途に合うツールを選び、対象プロジェクトで確かめる。シェルでは一つのコマンドに一つの仕事を任せ、標準入出力でつなぐ。
5. 既存の確認を使い、対象の失敗を検出できる最小の検証と、利用者の操作経路での確認を実行する。新しいワークフロー、CI、テスト、スクリプト、フックは具体的な失敗を検出するか、実測した繰り返し作業を減らす場合に加える。整理では重複した確認を取り除き、削減した件数や工数を測る。
6. 対象リポジトリの規約に従って配布する。Kafstylerでは[作業規約](../AGENTS.md#ブランチとコミット)に従い、同じチェックアウトで作業し、確認した変更単位ごとに `main` にコミットする。PRを使うリポジトリでは差分、マージ、反映、後片付けまで確認する。

動作する変更と根拠を届ける。実行を妨げる問題が残る場合は次の作業を示す。

## 関連ミッション

[自律改善](../MISSION.md#mission-improvement)・[自律成果創出](../MISSION.md#mission-delivery)・[外部手法への置き換え](../MISSION.md#mission-adopt-upstream)

## 参照資料

- [Anthropic・Agent Skills執筆ガイド](../CANON.md#canon-anthropic-skill-authoring)
- [Anthropic・Claude Code Skills](../CANON.md#canon-claude-code-skills)
- [Anthropic・Claude Codeプラグインの作成](../CANON.md#canon-claude-plugin-creation)
- [Anthropic・プラグインの構成要素](../CANON.md#canon-claude-plugin-components)
- [Anthropic・プラグインマニフェスト仕様](../CANON.md#canon-claude-plugin-manifest)
- [Anthropic・Claude Codeの実践ガイド](../CANON.md#canon-claude-code-practices)
- [Pydantic・検証の公式ドキュメント](../CANON.md#canon-pydantic)
- [Astral・uv](../CANON.md#canon-astral-uv)
- [Astral・Ruff](../CANON.md#canon-astral-ruff)
- [Astral・ty](../CANON.md#canon-astral-ty)
- [Google Gemini・DemoLabのフロントエンド設計スキル](../CANON.md#canon-google-demolab)
- [ComfyUI・公式ドキュメント](../CANON.md#canon-comfyui-docs)
- [ComfyUI・Workflow Templatesの使い方](../CANON.md#canon-comfyui-workflow-templates)
- [ComfyUI・公式テンプレートの正本](../CANON.md#canon-comfyui-template-source)
- [ComfyUI・Workflow JSON仕様原本](../CANON.md#canon-comfyui-workflow-json)
- [Pulumi・Infrastructure as Code](../CANON.md#canon-pulumi-iac)
- [Pulumi・変更の事前確認（pulumi preview）](../CANON.md#canon-pulumi-preview)
- [Tripo Studio・公式ドキュメント](../CANON.md#canon-tripo-studio)
- [Tripo API・公式ドキュメント](../CANON.md#canon-tripo-api)
- [Tripo・ComfyUIノードの公式ドキュメント](../CANON.md#canon-tripo-comfyui)
- [Tripo / VAST AI・論文一覧](../CANON.md#canon-tripo-publications)
- [Microsoft・General Naming Conventions](../CANON.md#canon-general-naming)
- [DeepSeek Harness・公式開発者ドキュメント](../CANON.md#canon-deepseek-harness-docs)
- [DeepSeek Harness・アーキテクチャ](../CANON.md#canon-deepseek-harness-architecture)
- [McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](../CANON.md#canon-unix-philosophy)
- [汎用Unity・CoplayDev/unity-mcp](../CANON.md#canon-unity-coplay)
- [VRChat Worlds・swax/UnityMCP-VRC](../CANON.md#canon-vrc-worlds)
- [VRChat Avatars・lighfu/unity-agent](../CANON.md#canon-vrc-avatars)
- [Agent Skills・仕様](../CANON.md#canon-agent-skills-standard)
- [Model Context Protocol・Tools](../CANON.md#canon-mcp-tools)
- [OpenAI・Harness engineering](../CANON.md#canon-openai-harness-engineering)
- [Anthropic・Effective harnesses for long-running agents](../CANON.md#canon-anthropic-long-running-harness)
- [Chip Huyen・AI Engineering](../CANON.md#canon-chip-huyen-ai-engineering)
- [Manning・Agent Engineering](../CANON.md#canon-manning-agent-engineering)
- [かふかのZenn記事一覧](../CANON.md#canon-kafka-zenn)
- [imoz・日本語の文章編集ガイド](../CANON.md#canon-humanizer-ja)
- [ISUCON2026 で優勝しました（準備編）](../CANON.md#canon-isucon-preparation)
- [fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](../CANON.md#canon-isucon-harness)
- [OpenAI・現場で成果を届けるエンジニアリング（What FDE means at OpenAI）](../CANON.md#canon-openai-fde)
