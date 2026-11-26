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

## 操作の選び方

同じ目的の実行手段を並行導入しない。先に対象案件の採用版・認可・実行環境を選び、該当する操作だけ読む。各入口は公式のCLI・Skill・API・スキーマを呼ぶためのものとし、リンクのみの項目を実行済みのコマンドや導入済み機能とみなさない。

## 知識とデータ

**OKF v0.3**：[仕様](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/SPEC.md) · [okf-generate](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-generate/SKILL.md) · [okf-consume](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-consume/SKILL.md)。生成・更新はgenerate、読取り・検索はconsumeを使う。本文の仕様を複製しない。導入先が採用版の公式Skillを配布する。

CLI検索では、採用版の上流checkoutを `OKF_ROOT` に指定し、Python 3.9以上とPyYAMLを導入環境で用意し、同じ依存ロックを再利用する。初回導入時だけ上流を利用環境の外部資材ディレクトリへ取得し、`git -C "$OKF_ROOT" checkout --detach 527e81aff55992be21507e97004286789126f88c` で採用版を指定する。Kafstyler本体のブランチは変更しない。例：`mise run okf-scan ./vault --grep "topic"`。出力はJSON。入力はbundle rootと検索条件。

**Knowledge Compiler 1.3.1**：[採用版README](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/README.md) · [CLI安定性契約](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/STABILITY.md)。Python 3.10以上。必要な実行環境で導入する例：

```sh
mise run vault-install
```

| 操作 | 共通タスク |
| --- | --- |
| 保管庫の初期化 | `mise run vault-init --target ./vault` |
| 原資料の取り込み | `mise run vault-extract ./source.pdf --vault ./vault` |
| 知識検索 | `mise run vault-query "topic" --vault ./vault --json` |
| 既知の誤情報を修正 | `mise run vault-correct "正しい記述" --stale "旧記述" --target "NOTE" --vault-path ./vault --apply --json` |
| グラフ表示 | `mise run vault-graph ./vault` |
| 既存の取り込み・修復・コミット | `OBSIDIAN_VAULT_PATH=/path/to/vault mise run vault-maintain` |

`vault-correct` は `--apply` がない場合は書き込まない。修正対象と新旧の記述が特定され、書き込みが認可された場合だけ実行する。上流が保持する歴史資料を改変しない。

保守の環境変数・排他・Git/非Gitモードは[既存スクリプト](scripts/vault-maintenance.sh)を正本とする。保守タスクは書き込みを伴うため閲覧用途では使わない。

その他の形式・意味の契約：[JSON Schema 2020-12](https://json-schema.org/draft/2020-12)（構造） · [W3C PROV-O](https://www.w3.org/TR/prov-o/)（来歴） · [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/)（カタログ） · [SKOS](https://www.w3.org/TR/skos-reference/)（概念） · [dbt Sources](https://docs.getdbt.com/docs/build/sources)（データ依存） · [Obsidian Properties](https://obsidian.md/help/properties)（保管庫の属性）。案件の採用形式だけを使う。

### 知識の検索・整形・変換

| 操作 | 定義済みの入口 |
| --- | --- |
| OKFの生成・移行 | 上記の公式 `okf-generate` Skill。生成する文書に `type`、ルート目次に `okf_version: "0.3"`、サブ目次・logは仕様に従う。相対Markdownリンクを使う |
| OKFの絞り込み | `mise run okf-scan PATH --type TYPE` / `--tag TAG` / `--grep TEXT` |
| Obsidianの検索・読取 | `obsidian vault=VAULT search query="TEXT"` / `obsidian vault=VAULT read path="NOTE.md"`（[公式CLI](https://obsidian.md/help/cli)、[公式Skill](https://github.com/obsidianmd/obsidian-skills/blob/main/plugins/obsidian/skills/obsidian-cli/SKILL.md)） |
| Obsidianの属性・リンク・一覧 | [Properties](https://obsidian.md/help/properties) · [Tags](https://obsidian.md/help/tags) · [Links](https://obsidian.md/help/links) · [Bases](https://obsidian.md/help/bases)。CLI未導入なら既存Markdownを直接読む |
| Obsidian拡張 | [公式プラグイン台帳](https://github.com/obsidianmd/obsidian-releases/blob/master/community-plugins.json) · [配布契約](https://github.com/obsidianmd/obsidian-releases#community-plugins) · [対応版](https://docs.obsidian.md/Reference/Versions) |
| 知識の意味と来歴 | [Foundry Ontology](https://www.palantir.com/docs/foundry/ontology/overview/) · [Data Lineage](https://www.palantir.com/docs/foundry/data-lineage/overview/)：採用環境のオブジェクト・リンク・来歴を使う |
| データ変換 | `dbt ls --select SELECTOR`（対象の列挙）、`dbt run --select SELECTOR`（モデル実体化）、`dbt docs generate`（成果物生成）。[CLI](https://docs.getdbt.com/reference/dbt-commands) · [ref()](https://docs.getdbt.com/reference/dbt-jinja-functions/ref) |
| 形式変換 | `pandoc input.md -o output.docx`（[公式仕様](https://pandoc.org/MANUAL.html)）。出力形式に必要な依存は利用先で管理 |
| 構造データの入出力 | [Pydantic](https://pydantic.dev/docs/validation/latest/get-started/)：採用モデルの `model_validate` / `model_dump` を入出力契約として使う。独立した検証工程は作らない |
| 命名 | [Microsoft Naming Conventions](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/general-naming-conventions)。対象言語・データモデルの公開契約を優先 |

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

### エージェントの起動・再開・拡張

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

### Orcaの操作契約

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

### 開発・OS・配布の具体操作

| 操作 | コマンド・契約 |
| --- | --- |
| 開発環境 | `mise install` / `mise exec -- COMMAND` / `mise run TASK`。[tools/env/tasks](https://mise.jdx.dev/configuration.html)。共有版は設定に置き、言語別の重複経路を増やさない |
| Gitの作業状態 | `git status --porcelain=v1 -uall` / `git worktree list --porcelain` / `git branch --list`。必要な変更を `git add PATH` → `git commit -m MESSAGE` → `git push origin main`。非強制、単一書き手 |
| GitHubの作業 | `gh issue view NUMBER --repo OWNER/REPO` / `gh issue comment NUMBER --body TEXT` / `gh issue close NUMBER`。Issueは既存の仕事と結果の入口 |
| Python依存 | `uv sync --locked` / `uv run COMMAND` / `uv lock`（更新時のみ）/[uv](https://docs.astral.sh/uv/) |
| Python整形・型 | `ruff format PATH`、[Ruff](https://docs.astral.sh/ruff/) · [ty](https://docs.astral.sh/ty/)。型解析・静的解析の専用検証工程は起動しない |
| データ・ローカルDB | `sqlite3 -readonly DB "SELECT ..."` / `duckdb -c "SELECT ..."`（[SQLite CLI](https://sqlite.org/cli.html) · [DuckDB CLI](https://duckdb.org/docs/stable/clients/cli/overview)）。SQLは明示されたデータ契約に従う |
| APIと構造データ | `curl --fail-with-body URL` / `jq FILTER FILE` / [OpenAPI](https://spec.openapis.org/oas/latest.html)。認証・書込みは対象サービスの認可範囲 |
| 運用と同期 | `rclone copy SOURCE DEST`。削除を伴うsyncは既存の認可されたキャッシュ処理以外で無条件に使わない。[combine](https://rclone.org/combine/) · [XDG](https://specifications.freedesktop.org/basedir-spec/latest/) |
| OSの起動契約 | [systemd.timer](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html) · [Windows Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page) · [WSL相互運用](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings) · `Get-Command NAME`。既存スケジュールを利用 |
| インフラ | `pulumi stack select STACK` / `pulumi up`。認可されたstackのみ変更。[Pulumi](https://www.pulumi.com/docs/iac/) |
| リリース・依存更新 | [Renovate mise manager](https://docs.renovatebot.com/modules/manager/mise/) · [Automerge](https://docs.renovatebot.com/key-concepts/automerge/) · [Release Please](https://github.com/googleapis/release-please)。既存の配布構成を利用 |
| 秘密情報 | [SOPS mise連携](https://mise.jdx.dev/environments/secrets/sops.html) · [Gitleaks](https://github.com/gitleaks/gitleaks)。秘密をログや会話に出さない。独立した検査ジョブは追加しない |
| 実行資材 | [agrの設計思想](https://zenn.dev/kafka2306/articles/9f9997babac335) · [公式Agent Skills配布仕様](https://agentskills.io/specification)。既存資材から選び、個別のインストール手順を複製しない |

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

### 制作・公開・情報収集の具体操作

| 操作 | 定義済みの入口 |
| --- | --- |
| UIの構造と部品 | [Journey](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/journey.ts) · [Decision](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/decision.tsx) · [Content Schema](https://github.com/KAFKA2306/design/blob/main/artifacts/content.schema.json) · [Tokens](https://github.com/KAFKA2306/design/blob/main/tokens/foundation.tokens.json) · [Frontend Skill](https://github.com/KAFKA2306/design/blob/main/skills/frontend-design/SKILL.md)。利用先のdesign.config.jsonで採用版を指定 |
| 画面の生成 | [DemoLab](https://github.com/google-gemini/demolab#installation)、公式Skillを利用 |
| ComfyUIの選定・生成 | [案件共通のworkflow選定](https://github.com/KAFKA2306/comfyui-workflows-factory/blob/main/docs/knowledge/best-workflows.md) → [公式テンプレート](https://github.com/Comfy-Org/workflow_templates) → [Workflow JSON](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx)。採用ノード・モデル・seed・入力・出力は案件workflowに固定 |
| 3D生成 | [Tripo Studio](https://www.tripo3d.ai/product-doc) · [Tripo API](https://developers.tripo3d.ai/en/docs/introduction) · [ComfyUI nodes](https://developers.tripo3d.ai/en/docs/comfyui-nodes)。画像からの復元、形状、トポロジー、動作の要求でモデルを選択 |
| 3D編集・自動化 | `blender -b FILE.blend --python SCRIPT.py` / [Blender CLI](https://docs.blender.org/manual/en/latest/advanced/command_line/)。Unityは既存プロジェクトのMCPまたは公式バッチ実行 |
| VRChat | [Worlds MCP](https://github.com/swax/UnityMCP-VRC) · [Modular Avatar Skill](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md) · [Avatar Build Skill](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md)。既存Unity環境・SDK・公開権限を利用 |
| 文書・記事 | `npx zenn new:article` / `npx zenn preview`（[Zenn CLI](https://zenn.dev/zenn/articles/zenn-cli-guide)）。[日本語編集](https://imoz.jp/humanizer.ja.txt) · [imozuru](https://github.com/MaryCache/imozuru) · [yomiyasu](https://github.com/nanaism/yomiyasu)：didactizationで用途に合う既存資材のみ使用 |
| 図・可視化 | [Mermaid](https://mermaid.js.org/intro/) · [Graphviz](https://graphviz.org/documentation/)。必要なときだけ成果物に含める |
| 画像・動画・音声 | `magick INPUT OUTPUT`（[ImageMagick](https://imagemagick.org/script/command-line-processing.php)）、`ffmpeg -i INPUT OUTPUT`（[FFmpeg](https://ffmpeg.org/ffmpeg.html)）。出力形式・コーデックは案件で指定 |
| 市場・企業・金融 | 指数は既存のMSCI/S&P方法論、企業は対象の開示・一次データ、信用構造は[BIS](https://www.bis.org/)・[ECB](https://www.ecb.europa.eu/)の公式公開資料。時点依存の数値・データIDを共通台帳に固定しない |
| 公開検索・GEO/AEO | [公開情報運用指針](https://zenn.dev/kafka2306/articles/6dd453d941b99f)。取得先と原文を分け、案件で必要な出典・データを保持する |

### 制作APIの入出力

GUIで保存したワークフローとAPI用の実行グラフを区別する。外部有料APIを呼ぶ操作は、対象案件で認可されたアカウント・費用・モデル・入力だけに限定する。

| 操作 | 実行契約 |
| --- | --- |
| ComfyUIローカル実行 | API形式のグラフJSONを `POST /prompt` の `prompt` に渡す。返却された `prompt_id` で `GET /history/{prompt_id}` を取得し、出力のfilename/subfolder/typeで `GET /view` を呼ぶ。[公式ルート](https://github.com/Comfy-Org/docs/blob/main/ja/development/comfyui-server/comms_routes.mdx) · [公式例](https://github.com/Comfy-Org/docs/blob/main/ja/development/comfyui-server/api-examples.mdx) |
| Tripo v3 | `POST /v3/files` で素材を登録、`POST /v3/generation/image-to-model` または `/v3/generation/multiview-to-model` で生成し、`GET /v3/tasks/{task_id}` で状態・成果URLを取得する。基点は `https://openapi.tripo3d.ai`、Bearer認証。HTTP成功とAPIの `code=0` を区別し、`status=success` の成果URLだけを利用する。[v3公式契約](https://developers.tripo3d.ai/en/docs/introduction) · [ライフサイクル](https://developers.tripo3d.ai/ja/docs/task-lifecycle) |
| Tripo後処理 | 同じv3契約の `POST /v3/models/texture`、`/v3/models/convert`、`/v3/mesh/decimate`、`/v3/animations/rig`、`/v3/animations/retarget` を要件に応じて使う。対象のモデル・タスクIDを明示し、旧v2契約と混ぜない |

ComfyUIの既存ローカルインスタンスへの投入例（`COMFY_URL` は認可された接続先、`workflow-api.json` はAPI用グラフ）：

```sh
jq '{prompt:.}' workflow-api.json |
  curl --fail-with-body -H 'Content-Type: application/json' --data-binary @- "${COMFY_URL:?Set COMFY_URL}/prompt"
```

Tripoの既存タスク取得例（キーは利用環境の秘密管理から注入し、値を記録しない）：

```sh
curl --fail-with-body -H "Authorization: Bearer ${TRIPO_API_KEY:?Set TRIPO_API_KEY}" "https://openapi.tripo3d.ai/v3/tasks/${TASK_ID:?Set TASK_ID}"
```

契約を採用する案件では、実際に使用するモデル・ノード・API版・入力JSON・出力先を案件の正本に固定する。共通台帳は個別の生成設定を保持しない。

### 旧聖典の扱い

旧聖典の七分野から、繰り返し使う操作・配布・スキーマ・上流Skillを上の実行入口へ移した。論文・書籍・事例・市場報告そのものをコマンドと見なさない。実装や導入が伴わない参照は公式契約または選定候補として区別する。旧版・個別環境の障害復旧・検証専用操作・不採用の重複経路は復活させない。

新たに繰り返す操作が見つかった場合は、既存CLI、公式Skill、既存miseタスクの順に再利用し、足りない操作だけ引数・入力・出力・依存・権限を明示して同じ正本へ追加する。
