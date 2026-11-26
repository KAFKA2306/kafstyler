---
type: guide
description: "採用済み標準と実行入口を再利用するための契約"
tags:
  - kafstyler/operation
---

# 実行契約

[聖典](BIBLES.md)は判断の根拠、ここは実行時に使う契約の入口とする。公式のCLI・Skill・APIが既にあるならそのまま呼び、複数案件で共通の実行経路だけを[mise.toml](mise.toml)に定義する。コマンドは実行環境が提供する認可済みのものに限る。

- 通常実行では採用済みの定義を使う。新規操作、版の変更、入力・出力契約の変更があった場合だけ公式資料を読む。
- 実行環境で採用する版はmise・パッケージ管理・ロックファイル・外部プラグインの配布契約で固定する。ホストのパス・アカウント・秘密情報は利用先に置く。更新は独立した変更として扱い、毎回最新版に置き換えない。
- 必須入力、依存、権限がなければ停止する。外部Skillの検証工程や監査を自動的に追加しない。取り込みや修復は認可された実データに限る。
- 定義済みタスク一覧は `mise tasks`。未採用のツールを一括導入しない。以下の参照例は必要な機能が認可・導入されている場合だけ使う。

## 知識とデータ

**OKF v0.3**：[仕様](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/SPEC.md) · [okf-generate](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-generate/SKILL.md) · [okf-consume](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-consume/SKILL.md)。生成・更新はgenerate、読取り・検索はconsumeを使う。本文の仕様を複製しない。導入先が採用版の公式Skillを配布する。

CLI検索では、採用版の上流checkoutを `OKF_ROOT` に指定し、Python 3.9以上とPyYAMLを導入環境で用意する。例：`mise run okf-scan ./vault --grep "topic"`。出力はJSON。入力はbundle rootと検索条件。

**Knowledge Compiler 1.3.1**：[採用版README](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/README.md) · [CLI安定性契約](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/STABILITY.md)。Python 3.10以上。必要な実行環境で導入する例：

```sh
uv tool install 'knowledge-compiler[extract] @ git+https://github.com/GoogleCloudPlatform/knowledge-compiler.git@52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe'
```

| 操作 | 共通タスク |
| --- | --- |
| 保管庫の初期化 | `mise run vault-init --target ./vault` |
| 原資料の取り込み | `mise run vault-extract ./source.pdf --vault ./vault` |
| 知識検索 | `mise run vault-query "topic" --vault ./vault` |
| グラフ表示 | `mise run vault-graph ./vault` |
| 既存の取り込み・修復・コミット | `OBSIDIAN_VAULT_PATH=/path/to/vault mise run vault-maintain` |

保守の環境変数・排他・Git/非Gitモードは[既存スクリプト](scripts/vault-maintenance.sh)を正本とする。保守タスクは書き込みを伴うため閲覧用途では使わない。

その他の形式・意味の契約：[JSON Schema 2020-12](https://json-schema.org/draft/2020-12)（構造） · [W3C PROV-O](https://www.w3.org/TR/prov-o/)（来歴） · [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/)（カタログ） · [SKOS](https://www.w3.org/TR/skos-reference/)（概念） · [dbt Sources](https://docs.getdbt.com/docs/build/sources)（データ依存） · [Obsidian Properties](https://obsidian.md/help/properties)（保管庫の属性）。案件の採用形式だけを使う。

## エージェント・連携

| 対象 | 実行入口・契約 |
| --- | --- |
| Kafstyler | [既存7 Skills](AGENTS.md#スキルの役割)と[各CLIへの導入](README.md#プラグインの使い方) |
| 外部Skill | [Agent Skills仕様](https://agentskills.io/specification)：SKILL.mdと必要時のscripts・references・assets |
| ツール接続 | [MCP Tools](https://modelcontextprotocol.io/specification/2025-11-25/server/tools)：認可済みサーバーのtools/list・tools/call、宣言済み入出力 |
| HTTP API | [OpenAPI](https://spec.openapis.org/oas/latest.html)：対象サービスの採用版とoperationId・入力・認証 |
| Claude Code | [Skills](https://code.claude.com/docs/en/skills) · [Hooks](https://code.claude.com/docs/en/hooks) · [Agent SDK](https://code.claude.com/docs/en/agent-sdk) |
| Codex | [プラグイン](https://developers.openai.com/plugins/build/plugins) · [Skills](https://learn.chatgpt.com/docs/build-skills) |
| Antigravity | [CLI](https://antigravity.google/docs/getting-started?tab=cli) · [Headless](https://antigravity.google/docs/cli/headless/) |
| Orca | [接続入口](integrations/orca/README.md) · [CLI](https://orca.dev/docs/cli/reference) · [Skills](https://orca.dev/docs/cli/skills)。導入済みなら `orca skills get orchestration --full` で契約を取得 |
| モデル選定 | `mise run model-select --policy PATH`。利用先の設定を正本とする |

既存実行基盤の単一書き手・認可・再開条件を守る。製品ごとの常駐実装やコマンド構文を自作しない。

## 開発・実行・運用

| 用途 | 採用済み環境で使う公式入口 |
| --- | --- |
| 環境と共通タスク | `mise tasks` / `mise run TASK` / [定義仕様](https://mise.jdx.dev/tasks/task-configuration.html) |
| ソース・履歴 | `git status --short` / `git diff` / [Git](https://git-scm.com/docs) |
| 案件・Issue | `gh issue list --repo OWNER/REPO --state open` / [GitHub CLI](https://cli.github.com/manual/) |
| ファイル・テキスト探索 | `rg -n PATTERN PATH` / [ripgrep](https://github.com/BurntSushi/ripgrep) |
| JSON加工 | `jq FILTER FILE` / [jq](https://jqlang.org/manual/) |
| ファイル転送 | `rclone copy SOURCE DEST` / [rclone](https://rclone.org/commands/rclone_copy/) |
| Python実行・依存 | `uv run COMMAND` / [uv](https://docs.astral.sh/uv/) |
| HTTP実装 | [Hono](https://hono.dev/docs/) と対象のWeb標準 |
| インフラ変更 | [Pulumi IaC](https://www.pulumi.com/docs/iac/) と対象の既存stack |
| 依存更新・リリース | [Renovate](https://docs.renovatebot.com/) · [Release Please](https://github.com/googleapis/release-please) |
| 秘密情報 | [SOPS](https://getsops.io/docs/) と利用環境の認可済み鍵 |

標準コマンドに独自ラッパーを重ねない。案件の定型処理は利用先のmiseタスクへ定義し、横断する契約だけ共有する。

## 制作・公開・分析

| 用途 | 公式入口 |
| --- | --- |
| 共通UI | [KAFKA2306/design](https://github.com/KAFKA2306/design) の採用版と利用先の設定 |
| 画像ワークフロー | [ComfyUI](https://docs.comfy.org/) · [Workflow JSON](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx) · [公式テンプレート](https://github.com/Comfy-Org/workflow_templates) |
| 3D生成 | [Tripo API](https://developers.tripo3d.ai/en/docs/introduction) と案件が選ぶモデル |
| 3D処理・レンダリング | [Blender CLI](https://docs.blender.org/manual/en/dev/advanced/command_line/) · [Unity MCP](https://github.com/CoplayDev/unity-mcp) |
| VRChat制作 | [Worlds・UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC) · [Avatars・unity-agent](https://github.com/lighfu/unity-agent) |
| 文書・記事公開 | [Zenn CLI](https://zenn.dev/zenn/articles/zenn-cli-guide) と公開先の公式契約 |
| 金融データ | [MSCI指数方法論](https://www.msci.com/indexes/index-resources/index-methodology) · [S&P指数方法論](https://www.spglobal.com/spdji/en/methodology/article/sp-us-indices-methodology/) と各データ提供元の採用版 |

製品固有のworkflow、Unityプロジェクト、公開先、データ契約、取引方針は対象案件の正本に置く。ここへ個別設定や成果を転記しない。
