---
type: guide
description: "エージェント・連携の実行契約"
tags:
  - kafstyler/operation
---

# エージェント・連携

| 対象 | 実行入口・契約 |
| --- | --- |
| Kafstyler | [既存7 Skills](../AGENTS.md#スキルの役割)と[各CLIへの導入](../README.md#プラグインの使い方) |
| 外部Skill | [Agent Skills仕様](https://agentskills.io/specification)：SKILL.mdと必要時のscripts・references・assets |
| ツール接続 | [MCP Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools)：認可済みサーバーのtools/list・tools/call、宣言済み入出力 |
| HTTP API | [OpenAPI](https://spec.openapis.org/oas/latest.html)：対象サービスの採用版とoperationId・入力・認証 |
| Claude Code | [Skills](https://code.claude.com/docs/en/skills) · [Hooks](https://code.claude.com/docs/en/hooks) · [Agent SDK](https://code.claude.com/docs/en/agent-sdk) |
| Codex | [プラグイン](https://developers.openai.com/plugins/build/plugins) · [Skills](https://learn.chatgpt.com/docs/build-skills) |
| Antigravity | [CLI](https://antigravity.google/docs/getting-started?tab=cli) · [Headless](https://antigravity.google/docs/cli/headless/) |
| Orca | [接続入口](../integrations/orca/README.md) · [CLI](https://orca.dev/docs/cli/reference) · [Skills](https://orca.dev/docs/cli/skills)。導入済みなら `orca skills get orchestration --full` で契約を取得 |
| モデル選定 | `mise run model-select --policy PATH`。利用先の設定を正本とする |

既存実行基盤の単一書き手・認可・再開条件を守る。製品ごとの常駐実装やコマンド構文を自作しない。

## エージェントの起動・再開・拡張

| 操作 | 定義済みの入口 |
| --- | --- |
| Claude Codeの対話・再開 | `claude -p "TASK"`（単発）、`claude --resume SESSION_ID`（既存）。[公式コマンド](https://code.claude.com/docs/en/commands#all-commands) |
| Claude Codeの目標・常駐 | `/goal` · `/loop` · `/bg`。セッション内とクラウド実行を区別。[Goal](https://code.claude.com/docs/en/goal) · [Loop](https://code.claude.com/docs/en/scheduled-tasks) · [Agent view](https://code.claude.com/docs/en/agent-view) |
| Claude Codeの受付・PR | [Routines](https://code.claude.com/docs/en/routines) · [Desktop scheduled tasks](https://code.claude.com/docs/en/desktop-scheduled-tasks) · [Claude Ship](https://code.claude.com/docs/ja/claude-ship)（`/ship`・`/steward` は [対応版の仕様](https://code.claude.com/docs/ja/ship-command)）。main一本に反する自動PR経路は採用しない |
| Claude拡張 | [Plugin作成](https://code.claude.com/docs/en/plugins/create) · [Hooks](https://code.claude.com/docs/en/hooks) · [公式Skillマーケット](https://github.com/anthropics/claude-plugins-official)。イベント・権限・入出力はマニフェスト正本に従う |
| Claude Managed Agents | [Overview](https://platform.claude.com/docs/en/managed-agents/overview) · [Scheduled deployments](https://platform.claude.com/docs/en/managed-agents/scheduled-deployments) · [Memory](https://platform.claude.com/docs/en/managed-agents/memory)。既存セッション・権限・保存先を指定 |
| Codexの起動・再開 | `codex exec "TASK"`（単発）、`codex resume SESSION_ID`（既存）。[CLI](https://developers.openai.com/codex/cli/) · [Hooks](https://learn.chatgpt.com/docs/hooks) · [Plugin commands](https://learn.chatgpt.com/docs/developer-commands#codex-plugin) |
| Codex・ChatGPTの長期作業 | [Goals](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex) · [Codex Cloud](https://learn.chatgpt.com/docs/cloud) · [Scheduled tasks](https://learn.chatgpt.com/docs/automations) · [Dots](https://learn.chatgpt.com/docs/dots/tasks-and-memory)。採用環境でのみ利用 |
| OpenAIの非同期API | [Agents API sessions](https://developers.openai.com/api/docs/guides/agents-api/sessions) · [Automations](https://developers.openai.com/api/docs/guides/agents-api/sessions/automations) · [Session webhooks](https://developers.openai.com/api/docs/guides/agents-api/sessions/webhooks) · [Errors](https://developers.openai.com/api/docs/guides/agents-api/errors) · [Responses background mode](https://developers.openai.com/api/docs/guides/background)。既存IDと認可を再利用 |
| Antigravity拡張・実行 | `agy plugin install URL`（既存配布契約）。[Plugin作成](https://antigravity.google/docs/build-plugins/) · [JSON Schema](https://antigravity.google/schemas/v1/plugin.json) · [認証](https://antigravity.google/docs/install?tab=cli) · [Headless](https://antigravity.google/docs/cli/headless/) |
| DeepSeek Harness | `npx @deepseek-ai/dsh@VERSION web --no-open`。VERSIONは採用済みnpm版に置き換える。[公式README](https://github.com/deepseek-ai/deepseek-harness) · [公式操作・拡張](https://deepseek-harness.github.io/deepseek-harness/)。開発プレビューのため版とプロファイルを固定し、未導入なら自動起動しない |
| 共通の監督 | [tj-loop Skill](https://github.com/laiso/tj-loop/blob/8bc68994165cd2834bbbf3048fe3dd917b35c290/tj-loop/SKILL.md) · [agent-sessions-supervisor Skill](https://github.com/laiso/agent-sessions/blob/7bc74d7179de52cdbfe020700c434d60c5d68901/skills/agent-sessions-supervisor/SKILL.md) · [CLI README](https://github.com/laiso/agent-sessions/blob/7bc74d7179de52cdbfe020700c434d60c5d68901/README.md)。採用版checkout内で `./agent-sessions --source orca --format json`（一覧）、`./agent-sessions read TARGET`（読取）、認可された相手に限り `./agent-sessions send TARGET MESSAGE`（一度だけ送信）。既存ワーカーの観測・連絡に限定し、二重監督しない |
| 代替基盤 | [Rex](https://www.superlogical.com/rex/docs/installation) · [agent-dispatchの既存実装](https://github.com/shotayagami/agent-dispatch/tree/2fee8ad4f8644a1e6849ea14cf39d3f614e28a86) · [Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/)。役割の不足があるときだけ置換候補にする |

## Orcaの操作契約

| 操作 | 公式入口 |
| --- | --- |
| 接続・作業場所 | `orca status --json` / `orca worktree current --json` |
| セッション検索・端末操作 | `orca search`、`orca terminal list/show/read/wait/send`（[CLI](https://orca.dev/docs/cli/reference)）。送信は対象・認可が明確な場合だけ |
| 実行版の組み込みSkill | `orca skills installed --json` / `orca skills get orca-cli --full` / `orca skills get orchestration --full`。他の公式Skillは computer-use、orca-linear、orca-emulator、orca-emulator-android、orca-per-workspace-env |
| 監督付き委譲 | [Orchestration](https://orca.dev/docs/cli/orchestration)：run-create → task-create → worker-start、既存checkout指定、check/ack、worker-release。正確な引数は実行版の組み込みSkillを正本とする |
| 常駐・起動 | [Automations](https://orca.dev/docs/cli/automations)：既存Workspaceを指定する `--workspace`、既存実行元のlist/show、必要な場合だけreuse-session |
| Bots・通信 | [Bots](https://orca.dev/docs/bots) · [Connectors](https://orca.dev/docs/bots/connectors) · [Security](https://orca.dev/docs/bots/security)。受付・Needs you・イベントの権限を区別 |
| 画面・端末 | `orca goto URL` / `orca snapshot`、[Computer use](https://orca.dev/docs/cli/computer-use)・組み込みSkill。APIで処理できる場合はAPIを優先 |
| 遠隔・モバイル | [Remote Servers](https://orca.dev/docs/remote-servers) · [Mobile](https://orca.dev/docs/mobile) · [Usage](https://orca.dev/docs/agents/usage-tracking)。ホストの認可と利用枠を維持 |
| 拡張 | [Plugin catalog](https://orca.dev/plugins) · [Manifest](https://github.com/stablyai/orca/blob/main/docs/reference/plugin-manifest.md) · [MCP settings](https://orca.dev/docs/cli/skills#mcp-servers)。Excalidraw、Spreadsheet、SQLite Browser、Word Document Viewer、Image Markupは必要時だけ選ぶ |

Orca標準の新規worktree・自動PRはKafstylerのmain一本と競合するため、既存checkoutの単一書き手を優先する。No Worktrees等のコミュニティ拡張を排他の代わりにしない。
