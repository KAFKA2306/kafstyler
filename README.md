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

Kafstylerは、Claude CodeとCodexのAIエージェントが、開発・調査・制作・運用で何をもって完了とするかを決め、成果物を検証して届けるためのプラグインです。文章の推敲やデータ設計など、作業に応じてスキルを組み合わせます。複数の仕事に共通する手順の漏れが見つかれば、再現してKafstyler自体を直します。

## プラグインの使い方

### Claude Code

Claude Code 2.1.292以降で、ターミナルから次のコマンドを実行します。WindowsではWSLかGit Bashを使います。[配布元](https://github.com/KAFKA2306/agent-resources/blob/main/.claude-plugin/marketplace.json)

```sh
claude plugin install kafstyler --marketplace KAFKA2306/agent-resources --scope user
```

対象プロジェクトで `claude` を起動します。

### Codex

ターミナルで配布元を追加し、プラグインを導入します。WindowsではWSLで実行します。

```sh
codex plugin marketplace add KAFKA2306/kafstyler
codex plugin add kafstyler@kafstyler
```

対象プロジェクトで `codex` を起動し、`/hooks` でKafstylerのフックを確認・承認します。承認前もスキルは手動で選べます。更新後に再確認が表示されたら同じ操作を行います。[Codexのフック承認](https://learn.chatgpt.com/docs/hooks#review-and-trust-hooks)

### 依頼を送って使う

「READMEを初めて読む人が、手順どおりに起動できるように整えて」のように依頼します。

プラグインは、依頼を受け取るたびに各スキルの発動条件をエージェントへ渡します。スキル名を書かなくても、作業の段階ごとに該当するスキルを使うよう指示します。たとえば「台帳の列を統一し、移行後に旧ファイルを整理して」では、設計前に `schema`、移行後の削除前に `prune` を使います。委譲先にも同じ発動条件と[作業規約](AGENTS.md#コマンドの連携)を渡します。

エージェントがコミットするときは、毎回、記録する差分と検証結果を照合し、作成後にSHAと差分を確認します。コミットだけを頼んだ場合にも適用します。[コミットの手順](AGENTS.md#ブランチとコミット)

1. 普段の入口、成功と分かる結果、改善の比較基準を決めます。
2. 文書では、見出しから必要な手順を見つけ、記載どおりに操作できるかを確かめます。コードやデータでは、現物を同じ入力と合格条件で評価します。
3. 提出前に再確認が一度起動します。欠陥を直し、同じ条件で合否と改善幅を確かめます。Kafstylerの手順に原因があれば、再現して、正本に書き込める範囲で直します。[評価と自己改善の手順](skills/charter/SKILL.md#成果物の確認と手順の改善)

### プラグインの更新と検証

- Claude Codeでは `claude plugin update kafstyler@kafka-agent-tools` で更新し、新しいセッションを開始するか `/reload-plugins` を実行します。今後の改善版を自動取得するには、`/plugin` の Marketplaces で `kafka-agent-tools` の自動更新を有効にします。[Anthropicの更新手順](https://code.claude.com/docs/en/discover-plugins#keep-plugins-updated)
- Codexでは `codex plugin marketplace upgrade kafstyler` で配布元を更新し、`codex plugin add kafstyler@kafstyler` を実行して新しいセッションを開始します。[Codexのプラグインコマンド](https://learn.chatgpt.com/docs/developer-commands#codex-plugin)

### 作業中の版で試す

Kafstyler本体を変更したら、リポジトリのルートで `python3 hooks/check.py` を実行します。両プラグインの設定からフックを起動し、規約の読み込み、依頼の受付、委譲先への引き継ぎ、提出前の確認が一度で止まることを確かめます。

- Claude Codeでは `claude plugin validate .` を実行し、`claude --plugin-dir "$PWD"` で作業中の版を起動します。別プロジェクトで試すときも、`--plugin-dir` にKafstylerのチェックアウトの絶対パスを渡します。
- Codexでは検証用の `CODEX_HOME` を用意し、`codex plugin marketplace add "$PWD"` と `codex plugin add kafstyler@kafstyler` を実行します。プラグインは導入時点のコピーを使います。変更後に試し直す場合は、検証用の環境で `codex plugin remove kafstyler@kafstyler` を実行してから再導入します。新しいセッションの `/hooks` で検証する版のフックを確認・承認します。[ローカル配布元の仕様](https://developers.openai.com/plugins/build/plugins#how-local-marketplaces-work)

両クライアントでスキル名を含まない依頼を送り、スキルを使った時点を呼び出し履歴や `SKILL.md` の読み込みから確認します。手順の実行結果と成果物も照合します。提出前に漏れが見つかった場合は、該当する手順を実行し、その結果が影響する工程をやり直したことまで確かめます。[本体の変更手順](AGENTS.md#kafstyler本体の変更)

## スキル

Claude Codeでは `/kafstyler:<名前>` を使います。自律開発は [公式 `/loop` との連携手順](skills/deliver/SKILL.md#claude-codeの-loop-連携)に従い、`/loop 5m /kafstyler:deliver <依頼>` で始めます。Codexでは `$` を入力してKafstylerのスキルを選びます。

| スキル | 用途 |
| --- | --- |
| [`charter`](skills/charter/SKILL.md) | 利用者ができるようになることと合格条件を定める |
| [`humanizer`](skills/humanizer/SKILL.md) | タイトル、見出し、用語、本文を推敲し、根拠を確かめる |
| [`schema`](skills/schema/SKILL.md) | 台帳、マスター、集計モデルを設計する |
| [`scrutiny`](skills/scrutiny/SKILL.md) | 前提を疑い、重大な欠陥を根拠と影響で示す |
| [`benchmark`](skills/benchmark/SKILL.md) | 実物が合格条件を満たすか確かめ、比較する場合は同じ条件で差を測る |
| [`deliver`](skills/deliver/SKILL.md) | 変更を実装し、利用者の入口から確かめる |
| [`prune`](skills/prune/SKILL.md) | 参照先と動作を確かめ、不要なファイル、コード、文章を削る |

全スキルで、目標や成果物の前提を [`scrutiny`](skills/scrutiny/SKILL.md) で確かめます。重大な欠陥が見つかれば、元の作業で修正や再確認に使います。[連携手順](AGENTS.md#コマンドの連携)

定期タスクなどプラグインを使えない環境では、[作業規約](AGENTS.md#全作業への適用と自己改善)に従い、正本の版を固定して必要なスキルのMarkdownを使います。

## Unity・VRChatで制作する

汎用Unityは `CoplayDev/unity-mcp`、VRChat Worldsは `swax/UnityMCP-VRC`、VRChat Avatarsは `lighfu/unity-agent` を使用します。制作の共通規約は [AGENTS.md](AGENTS.md#全作業への適用と自己改善) です。

対象のUnity MCP・Agentは各リポジトリの公式手順で接続します。評価は利用者が使うUnity EditorやVRChat SDKで行います。

## 外部スキルとテンプレート

### Googleのフロントエンド設計スキル

KAFKA2306のWeb UIでは、先に[かふかのデザインパターン](BIBLES.md#かふかのデザインパターン)から操作の順番と共通部品を確認します。設計案の検討には、自律開発コマンドからGoogle Gemini DemoLabを使います。Claude Codeでの導入手順は次のとおりです。

```text
/plugin marketplace add google-gemini/demolab
/plugin install demolab@demolab
```

導入後、フロントエンド作業では `/demolab:gemini-frontend-design` を使います。[Gemini DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)

### ComfyUIのワークフローテンプレート

[Workflow選定と採用の基準](BIBLES.md#comfyuiのワークフロー選定)で制作目的に合う候補を探します。公式テンプレートを使う場合は、ComfyUIの `Workflow → Browse Workflow Templates` から開き、必要なモデルを確認して制作環境で出力を試します。[公式テンプレートの使い方](https://docs.comfy.org/interface/features/template) · [テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)

## ミッション・聖典・作業規約

Obsidianでは[リポジトリを保管庫として開く手順](BIBLES.md#ノートの管理)を使います。

- [MISSION.md](MISSION.md) ミッションと更新手順を確認できます。
- [聖典台帳](BIBLES.md) 分野別の一次資料と対応コマンドをたどれます。
- [AGENTS.md](AGENTS.md) 単一ブランチでの作業、逐次コミット、出力の共通ルールを確認できます。
