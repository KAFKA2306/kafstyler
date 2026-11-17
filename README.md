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

開発・調査・制作・運用で、AIエージェントが課題を見極め、使える成果を届けるためのClaude Codeプラグインです。

利用者が普段の操作で何をできるようになれば完了かを先に決めます。その状態から逆算して合格条件を定め、一次資料をもとに設計や手法の前提を見直します。成果物は実際の利用経路で検証し、その結果を文書の整備や、次の案件で使うスキルと道具の改善に生かします。

## プラグインの使い方

リポジトリのルートで次を実行します。

```sh
claude plugin validate .
claude --plugin-dir . --append-system-prompt-file AGENTS.md
```

2行目でプラグインと[作業規約](AGENTS.md)を読み込みます。Claude Codeで `/kafstyler:data` などのコマンドを選びます。手順は `skills/<name>/SKILL.md` にあります。

### 目標設定

- [`/kafstyler:scope`](skills/scope/SKILL.md) 利用者ができるようになることと、完了を確かめる操作を決める。

### 文書校正

- [`/kafstyler:edit`](skills/edit/SKILL.md) 原稿を校正するか、資料から短いブリーフを書く。

### メタデータ・スキーマ設計

- [`/kafstyler:data`](skills/data/SKILL.md) エンティティ、台帳、マスター、集計モデルの設計を決める。

### AIスロップ削除

- [`/kafstyler:clean`](skills/clean/SKILL.md) 重複フォルダを統合し、不要なファイル、コード、文章を削る。

### 評価と自律開発

- [`/kafstyler:critique`](skills/critique/SKILL.md) 中核の前提を反証し、致命的な欠陥を根拠と影響つきで指摘する。
- [`/kafstyler:test`](skills/test/SKILL.md) 同じ条件で採点し、合否と差を再現できるようにする。
- [`/kafstyler:build`](skills/build/SKILL.md) 変更を実装し、実際の利用経路で検証して届ける。

ChatGPTの定期タスクとCodexでは、[作業規約](AGENTS.md#全作業への適用と自己改善)と該当するコマンドのMarkdownを読み、実行環境の道具で手順を使います。

## Unity・VRChat制作での適用

汎用Unityは `CoplayDev/unity-mcp`、VRChat Worldsは `swax/UnityMCP-VRC`、VRChat Avatarsは `lighfu/unity-agent` を使用します。制作の共通規約は [AGENTS.md](AGENTS.md#全作業への適用と自己改善) です。

Claude Codeでは、このリポジトリをプラグインとして読み込み、同時に `AGENTS.md` を指示として渡します（上記「プラグインの使い方」参照）。対象のUnity MCP・Agentは各リポジトリの公式手順で別途接続してください。Kafstylerで目標設定、実装、検証、手順の改善を共通化します。

実作業で規約の不足を発見した場合は、[共通の改善手順](AGENTS.md#全作業への適用と自己改善)に沿って失敗の再現から進めます。Unity EditorやVRChat SDKで未検証の作業を完了扱いにしません。

## 外部スキルとテンプレート

### Googleのフロントエンド設計スキル

UIを設計するときは、自律開発コマンドからGoogle Gemini DemoLabを使う。Claude Code内の公式導入手順は次のとおり。

```text
/plugin marketplace add google-gemini/demolab
/plugin install demolab@demolab
```

導入後、フロントエンド作業では `/demolab:gemini-frontend-design` を使う。[Gemini DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)

### ComfyUIのWorkflow Templates

ComfyUIの `Workflow → Browse Workflow Templates` で用途に合うテンプレートを開く。採用したテンプレートと必要モデルを確認し、制作環境で出力を試す。[公式テンプレートの使い方](https://docs.comfy.org/interface/features/template) · [テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)

## 運用文書

Obsidianでは[リポジトリを保管庫として開く手順](BIBLES.md#ノートの管理)を使います。

- [MISSION.md](MISSION.md) ミッションと更新手順を確認できます。
- [聖典台帳](BIBLES.md) 分野別の一次資料と対応コマンドをたどれます。
- [AGENTS.md](AGENTS.md) 単一ブランチでの作業、逐次コミット、出力の共通ルールを確認できます。
