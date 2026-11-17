# Kafstyler

Claude Code plugin for recurring work. The repository also holds private ChatGPT memory and the Windows execution bridge.

## Use the plugin

From this repository's root, run:

```sh
claude plugin validate .
claude --plugin-dir .
```

The second command loads the plugin for the session. In Claude Code, choose a command such as `/kafstyler:data-design`.

### 目標設定

- [`/kafstyler:outcome-design`](commands/outcome-design.md) 利用者ができるようになることと、完了を確かめる操作を決める。

### 文書校正

- [`/kafstyler:editorial`](commands/editorial.md) 原稿を校正するか、資料から短いブリーフを書く。

### メタデータ・スキーマ設計

- [`/kafstyler:data-design`](commands/data-design.md) エンティティ、台帳、マスター、集計モデルの設計を決める。

### AIスロップ削除

- [`/kafstyler:remove-ai-slop`](commands/remove-ai-slop.md) 既存の成果物から、使い道のない文章や項目を削る。

### 評価と自律開発

- [`/kafstyler:devils-advocate`](commands/devils-advocate.md) 対立仮説を立て、どの事実なら判断が変わるかを示す。
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

## Repository guides

- [MISSION.md](MISSION.md) covers the update process, inventory, and reference links.
- [AGENTS.md](AGENTS.md) covers repository work and ownership.
- [Claude Code project instructions](.claude/CLAUDE.md) record when to adopt better upstream tools and skills.
- [MEMORY.md](MEMORY.md) holds durable memory. See [記憶の監査と同期](AGENTS.md#chatgpt-memory).
- [ChatGPT–Codex bridge](codex-chatgpt-bridge/README.md) covers Windows installation, the controller protocol, and status.
