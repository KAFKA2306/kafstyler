---
type: guide
description: "知識とデータの実行契約"
tags:
  - kafstyler/operation
---

# 知識とデータ

**OKF v0.3**：[仕様](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/SPEC.md) · [okf-generate](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-generate/SKILL.md) · [okf-consume](https://github.com/open-knowledge-format/open-knowledge-format/blob/527e81aff55992be21507e97004286789126f88c/skills/okf-consume/SKILL.md)。生成・更新はgenerate、読取り・検索はconsumeを使う。本文の仕様を複製しない。導入先が採用版の公式Skillを配布する。

CLI検索では、採用版の上流checkoutを `OKF_ROOT` に指定し、Python 3.12とPyYAML 6.0.2はmiseタスク内でuvが管理する。初回導入時だけ上流を利用環境の外部資材ディレクトリへ取得し、`git -C "$OKF_ROOT" checkout --detach 527e81aff55992be21507e97004286789126f88c` で採用版を指定する。Kafstyler本体のブランチは変更しない。例：`mise run okf-scan ./vault --grep "topic"`。出力はJSON。入力はbundle rootと検索条件。

**Knowledge Compiler 1.3.1**：[採用版README](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/README.md) · [CLI安定性契約](https://github.com/GoogleCloudPlatform/knowledge-compiler/blob/52e0f4bd2a01f2dec55c380d9ed4b42d38ace7fe/STABILITY.md)。実行にはmiseが管理するuvとPython 3.12を使い、上流の採用コミットをmise.tomlに固定する。単体CLIをホストへ明示的に導入する場合だけ以下を実行する（通常のmiseタスクには別途インストール不要）：

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

保守の環境変数・排他・Git/非Gitモードは[既存スクリプト](../skills/canonicalize/scripts/vault-maintenance.sh)を正本とする。保守タスクは書き込みを伴うため閲覧用途では使わない。

その他の形式・意味の契約：[JSON Schema 2020-12](https://json-schema.org/draft/2020-12)（構造） · [W3C PROV-O](https://www.w3.org/TR/prov-o/)（来歴） · [DCAT 3](https://www.w3.org/TR/vocab-dcat-3/)（カタログ） · [SKOS](https://www.w3.org/TR/skos-reference/)（概念） · [dbt Sources](https://docs.getdbt.com/docs/build/sources)（データ依存） · [Obsidian Properties](https://obsidian.md/help/properties)（保管庫の属性）。案件の採用形式だけを使う。

## 知識の検索・整形・変換

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
