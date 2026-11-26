---
type: guide
description: "開発・実行・運用の実行契約"
tags:
  - kafstyler/operation
---

# 開発・実行・運用

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

## 開発・OS・配布の具体操作

| 操作 | コマンド・契約 |
| --- | --- |
| 開発環境 | `mise install` / `mise exec -- COMMAND` / `mise run TASK`。[tools/env/tasks](https://mise.jdx.dev/configuration.html)。共有版は設定に置き、言語別の重複経路を増やさない |
| Gitの作業状態 | `git status --porcelain=v1 -uall` / `git worktree list --porcelain` / `git branch --list`。必要な変更を `git add PATH` → `git commit -m MESSAGE` → `git push origin main`。非強制、単一書き手 |
| GitHubの作業 | `gh issue view NUMBER --repo OWNER/REPO` / `gh issue comment NUMBER --body TEXT` / `gh issue close NUMBER`。Issueは既存の仕事と結果の入口 |
| Python依存 | `uv sync --locked` / `uv run COMMAND` / `uv lock`（更新時のみ）/[uv](https://docs.astral.sh/uv/) |
| Python整形・型 | `uv run ruff format PATH`、[Ruff](https://docs.astral.sh/ruff/) · [ty](https://docs.astral.sh/ty/)。型解析・静的解析の専用検証工程は起動しない |
| データ・ローカルDB | `sqlite3 -readonly DB "SELECT ..."` / `duckdb -c "SELECT ..."`（[SQLite CLI](https://sqlite.org/cli.html) · [DuckDB CLI](https://duckdb.org/docs/stable/clients/cli/overview)）。SQLは明示されたデータ契約に従う |
| APIと構造データ | `curl --fail-with-body URL` / `jq FILTER FILE` / [OpenAPI](https://spec.openapis.org/oas/latest.html)。認証・書込みは対象サービスの認可範囲 |
| 運用と同期 | `rclone copy SOURCE DEST`。削除を伴うsyncは既存の認可されたキャッシュ処理以外で無条件に使わない。[combine](https://rclone.org/combine/) · [XDG](https://specifications.freedesktop.org/basedir-spec/latest/) |
| OSの起動契約 | [systemd.timer](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html) · [Windows Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page) · [WSL相互運用](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings) · `Get-Command NAME`。既存スケジュールを利用 |
| インフラ | `pulumi stack select STACK` / `pulumi up`。認可されたstackのみ変更。[Pulumi](https://www.pulumi.com/docs/iac/) |
| リリース・依存更新 | [Renovate mise manager](https://docs.renovatebot.com/modules/manager/mise/) · [Automerge](https://docs.renovatebot.com/key-concepts/automerge/) · [Release Please](https://github.com/googleapis/release-please)。既存の配布構成を利用 |
| 秘密情報 | [SOPS mise連携](https://mise.jdx.dev/environments/secrets/sops.html) · [Gitleaks](https://github.com/gitleaks/gitleaks)。秘密をログや会話に出さない。独立した検査ジョブは追加しない |
| 実行資材 | [agrの設計思想](https://zenn.dev/kafka2306/articles/9f9997babac335) · [公式Agent Skills配布仕様](https://agentskills.io/specification)。既存資材から選び、個別のインストール手順を複製しない |
