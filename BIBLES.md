---
type: "reference"
description: "スキルやコマンドで使う一次資料を分野別に管理し、適用する手順と結び付ける。"
tags:
  - kafstyler/canon
  - kafstyler/reference
aliases:
  - "聖典台帳"
generated:
  by: openai/chatgpt
  at: "2026-11-22T03:16:36.100Z"
sources:
  - id: okf-v03-spec
    resource: https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/SPEC.md
  - id: anthropic-hooks
    resource: https://code.claude.com/docs/en/hooks
  - id: claude-code-goal
    resource: https://code.claude.com/docs/en/goal
  - id: claude-code-agent-view
    resource: https://code.claude.com/docs/en/agent-view
  - id: orca-automations
    resource: https://orca.dev/docs/cli/automations
  - id: orca-bot-connectors
    resource: https://orca.dev/docs/bots/connectors
  - id: orca-bot-security
    resource: https://orca.dev/docs/bots/security
  - id: orca-orchestration
    resource: https://orca.dev/docs/cli/orchestration
  - id: orca-remote-servers
    resource: https://orca.dev/docs/remote-servers
  - id: orca-plugin-manifest
    resource: https://github.com/stablyai/orca/blob/main/docs/reference/plugin-manifest.md
verified:
  - by: openai/chatgpt
    at: "2026-11-19T09:51:58Z"
  - by: openai/chatgpt
    at: "2026-11-19T10:14:33Z"
  - by: openai/chatgpt
    at: "2026-11-19T10:31:18Z"
  - by: openai/chatgpt
    at: "2026-11-19T10:48:56Z"
---
# 聖典台帳
必要な判断から[一次資料](#分野から探す)へ進む。運用規約は[AGENTS](AGENTS.md)。
## 分野から探す
- [設計とUI](bibles/design-and-ui.md)：かふかのデザインパターン・UIとComfyUI
- [知識とObsidian](bibles/knowledge-and-obsidian.md)：ノートの管理・データ・オントロジー・命名・Obsidian
- [使命・評価・執筆](bibles/mission-eval-writing.md)：目標・文章・評価・AIエンジニアリングの書籍・ISUCONのハーネス
- [金融と市場](bibles/finance-and-markets.md)：ファンドマネージャーの聖典
- [AIエージェントとOrca](bibles/agents-and-orca.md)：エージェントとハーネス・常駐エージェント
- [開発基盤と3D](bibles/dev-infra-and-3d.md)：CLI・開発・インフラ・ユニティとVRChatの制作ツール・Tripoと3D生成
- [かふかのZenn](bibles/kafka-zenn.md)：かふかのZenn
## 資料の見直し
根拠不足・リンク切れ・月次監査が生じたときだけ見直し、重複・旧版・用途を失った資料を退役する。日次の全分野巡回は行わず、変更がなければ無介入で終了する。
