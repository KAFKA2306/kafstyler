---
type: "guide"
description: "Kafstylerの目的、導入方法、スキルと外部ツールの使い方。"
tags:
  - kafstyler/guide
  - kafstyler/plugin
aliases:
  - "使い方"
---

# Kafstyler

Kafstylerは、Claude Codeで目標設定、成果物の評価、修正と再評価を回すプラグインです。普段の依頼を送ると動きます。使い方や評価に共通の漏れが見つかれば、再現してKafstyler自体の改善につなげます。

## プラグインの使い方

Claude Code 2.1.292以降で、ターミナルから次のコマンドを実行します。WindowsではWSLかGit Bashを使います。[配布元](https://github.com/KAFKA2306/agent-resources/blob/main/.claude-plugin/marketplace.json)

```sh
claude plugin install kafstyler --marketplace KAFKA2306/agent-resources --scope user
```

対象プロジェクトで `claude` を起動し、「READMEを初めて読む人が、手順どおりに起動できるように整えて」のように依頼します。

1. 普段の入口、成功と分かる結果、改善の比較基準を決めます。
2. 文書では必要な手順が見つかり、記載どおりに操作できるかを確かめます。コードやデータでは、現物を同じ入力と合格条件で評価します。
3. 提出前に再確認が一度起動します。欠陥を直し、同じ条件で合否と改善幅を確かめます。Kafstylerの手順に原因があれば、再現して、正本に書き込める範囲で直します。[評価と自己改善の手順](skills/charter/SKILL.md#成果物の確認と手順の改善)

### 更新と開発時の確認

導入済みの版は `claude plugin update kafstyler@kafka-agent-tools` で更新できます。すぐ使うには新しいセッションを開始するか、`/reload-plugins` を実行します。今後の改善版を自動取得するには、`/plugin` の Marketplaces で `kafka-agent-tools` の自動更新を有効にします。[Anthropicの更新手順](https://code.claude.com/docs/en/discover-plugins#keep-plugins-updated)

変更を公開前に試す場合は、Kafstylerのルートで `claude plugin validate .` を実行します。別のプロジェクトで `claude --plugin-dir /path/to/kafstyler` を起動し、普段の依頼を送ります。

## スキル

| 直接呼び出すとき | 用途 |
| --- | --- |
| [`/kafstyler:charter`](skills/charter/SKILL.md) | 完成場面と合格条件を定める |
| [`/kafstyler:humanizer`](skills/humanizer/SKILL.md) | 文書を校正し、手順と根拠を確かめる |
| [`/kafstyler:schema`](skills/schema/SKILL.md) | 台帳、マスター、集計モデルを設計する |
| [`/kafstyler:scrutiny`](skills/scrutiny/SKILL.md) | 前提を疑い、重大な欠陥を根拠と影響で示す |
| [`/kafstyler:benchmark`](skills/benchmark/SKILL.md) | 実物の合否と改善幅を同じ条件で測る |
| [`/kafstyler:deliver`](skills/deliver/SKILL.md) | 変更を実装し、利用者の入口から確かめる |
| [`/kafstyler:prune`](skills/prune/SKILL.md) | 重複や不要なファイル、コード、文章を削る |

ChatGPTの定期タスクとCodexでは、[作業規約](AGENTS.md#全作業への適用と自己改善)に従い、正本の版を固定して必要なスキルのMarkdownを使います。

## Unity・VRChat制作での適用

汎用Unityは `CoplayDev/unity-mcp`、VRChat Worldsは `swax/UnityMCP-VRC`、VRChat Avatarsは `lighfu/unity-agent` を使用します。制作の共通規約は [AGENTS.md](AGENTS.md#全作業への適用と自己改善) です。

対象のUnity MCP・Agentは各リポジトリの公式手順で接続します。評価は利用者が使うUnity EditorやVRChat SDKで行います。

## 外部スキルとテンプレート

### Googleのフロントエンド設計スキル

UIを設計するときは、自律開発コマンドからGoogle Gemini DemoLabを使う。Claude Code内の公式導入手順は次のとおり。

```text
/plugin marketplace add google-gemini/demolab
/plugin install demolab@demolab
```

導入後、フロントエンド作業では `/demolab:gemini-frontend-design` を使う。[Gemini DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)

### ComfyUIのWorkflow Templates

[Workflow選定と採用の基準](BIBLES.md#comfyuiのワークフロー選定)で制作目的に合う候補を探します。公式テンプレートを使う場合は、ComfyUIの `Workflow → Browse Workflow Templates` から開き、必要なモデルを確認して制作環境で出力を試します。[公式テンプレートの使い方](https://docs.comfy.org/interface/features/template) · [テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)

## 運用文書

Obsidianでは[リポジトリを保管庫として開く手順](BIBLES.md#ノートの管理)を使います。

- [MISSION.md](MISSION.md) ミッションと更新手順を確認できます。
- [聖典台帳](BIBLES.md) 分野別の一次資料と対応コマンドをたどれます。
- [AGENTS.md](AGENTS.md) 単一ブランチでの作業、逐次コミット、出力の共通ルールを確認できます。
