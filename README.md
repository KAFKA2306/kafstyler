# Kafstyler

定型作業を進めるためのClaude Codeプラグインです。

## プラグインの使い方

リポジトリのルートで次を実行します。

```sh
claude plugin validate .
claude --plugin-dir . --append-system-prompt-file AGENTS.md
```

2行目でプラグインと[作業規約](AGENTS.md)を読み込みます。Claude Codeで `/kafstyler:data-design` などのコマンドを選びます。

### 目標設定

- [`/kafstyler:outcome-design`](commands/outcome-design.md) 利用者ができるようになることと、完了を確かめる操作を決める。

### 文書校正

- [`/kafstyler:editorial`](commands/editorial.md) 原稿を校正するか、資料から短いブリーフを書く。

### メタデータ・スキーマ設計

- [`/kafstyler:data-design`](commands/data-design.md) エンティティ、台帳、マスター、集計モデルの設計を決める。

### AIスロップ削除

- [`/kafstyler:remove-ai-slop`](commands/remove-ai-slop.md) 重複フォルダを統合し、不要なファイル、コード、文章を削る。

### 評価と自律開発

- [`/kafstyler:devils-advocate`](commands/devils-advocate.md) 中核の前提を反証し、致命的な欠陥を根拠と影響つきで指摘する。
- [`/kafstyler:automated-evaluation`](commands/automated-evaluation.md) 同じ条件で採点し、合否と差を再現できるようにする。
- [`/kafstyler:autonomous-development`](commands/autonomous-development.md) 変更を実装し、実際の利用経路で検証して届ける。

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

- [MISSION.md](MISSION.md) ミッションと更新手順を確認できます。
- [聖典台帳](CANON.md) 分野別の一次資料と対応コマンドをたどれます。
- [AGENTS.md](AGENTS.md) 単一ブランチでの作業、逐次コミット、出力の共通ルールを確認できます。
