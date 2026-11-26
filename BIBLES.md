---
type: "reference"
description: "判断対象別の一次資料索引と、横断的な著者別出典を分離して管理する。"
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
  - id: tj-loop-skill
    resource: https://github.com/laiso/tj-loop/blob/8bc68994165cd2834bbbf3048fe3dd917b35c290/tj-loop/SKILL.md
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

**分類の軸は「何について判断するか」。** 主題別の入口は一つだけ選び、必要な原典を読む。共通の[作業規約](AGENTS.md)と[使命](MISSION.md)はここへ複製しない。

## 主題別の入口

| 判断対象 | 一次資料の入口 |
| --- | --- |
| **目的・合格条件・評価・文章**：何を解決するか、どう成果を確かめて説明するか | [使命・評価・執筆](bibles/mission-eval-writing.md) |
| **知識・データ**：情報の意味、来歴、識別子、保存・検索・整形の仕様 | [知識とObsidian](bibles/knowledge-and-obsidian.md) |
| **AIエージェントの実行・監督**：Skills、セッション、委譲、Orca、常駐と再開 | [AIエージェントとOrca](bibles/agents-and-orca.md) |
| **実装基盤・3D制作**：Git・開発CLI・環境管理（mise）・HTTP実装（Hono）・横断保守・インフラ、Unity・VRChat制作、Tripo・3Dモデル生成 | [開発基盤と3D](bibles/dev-infra-and-3d.md) |
| **UI・画像ワークフロー**：画面の操作と表示、ComfyUIのワークフロー・テンプレート | [設計とUI](bibles/design-and-ui.md) |
| **金融・投資**：市場、企業・指数、投資判断、信用リスク | [金融と市場](bibles/finance-and-markets.md) |

## 出典別の補助索引

- [かふかのZenn](bibles/kafka-zenn.md)：本人の公開記事から原文や経緯を探すための横断索引。主題別の第7分野にはしない。記事の内容について判断するときは、上の該当分野を入口にする。

## 境界の決め方

- **成果の良否を決める** → 使命・評価・執筆。**成果物の画面や操作を設計する** → 設計とUI。
- **記録する情報の構造を決める** → 知識とObsidian。**その取り込みをエージェントが継続実行する仕組みを決める** → AIエージェントとOrca。
- **AIワーカーの起動・監督を決める** → AIエージェントとOrca。**Git・OS・CLIや制作ツール自体の使い方を決める** → 開発基盤と3D。
- **画像ワークフローやUIを設計する** → 設計とUI。**3Dアセットを生成・編集する** → 開発基盤と3D。
- **金融上の意味や投資判断を決める** → 金融と市場。調査・記録・評価の共通手順は対応する主題へ振り分ける。

一つの案件が複数の問いを含む場合は、問いを分けて各主題へ進む。資料を重複転記して第二の正本を作らず、必要な関連先だけ参照する。

## 資料の見直し

根拠不足・リンク切れ・月次監査が生じたときだけ見直し、重複・旧版・用途を失った資料を退役する。日次の全分野巡回は行わず、変更がなければ無介入で終了する。
