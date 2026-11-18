---
type: "reference"
description: "スキルやコマンドで使う一次資料を分野別に管理し、適用する手順と結び付ける。"
tags:
  - kafstyler/canon
  - kafstyler/reference
aliases:
  - "聖典台帳"
---

# 聖典台帳

各項目の一次資料を開き、下のコマンドから適用手順を確認できる。[台帳の更新手順](MISSION.md#更新手順)・[評価指標](MISSION.md#機械的に確かめる評価指標)・[外部手法への置き換え](MISSION.md#外部実装への置き換え)

## 資料の見直し

1. 日次の保守タスクで、資料を掲載している分野を掲載順に一日一つずつ見直す。現行スキルで判断、操作、検証に使う資料を確かめ、公式資料の改訂や直近の作業で足りなかった根拠から候補を探す。
2. 候補の一次資料を開き、同じ作業で現行資料と比べる。判断や手順が具体的に改善するなら入れ替え、既存資料で扱えない用途があれば追加する。用途が重複する資料、公式の後継がある旧資料、現行の用途を示せない個別事例は整理する。公開日や参照回数だけで採否を決めない。改善を確かめられない日は現状を維持する。
3. 変更する場合は、一次URL、用途、対応スキルを台帳に記し、参照元と参照先を同じコミットで更新する。必須の仕様や手順を引き続き確認でき、リンク切れがないことを確かめる。採否の理由は作業記録に残し、台帳には現在使う資料を載せる。

## かふかのデザインパターン

[KAFKA2306/design](https://github.com/KAFKA2306/design) は、KAFKA2306のプロジェクトが共有するWeb UIの設計正本。共通部品、見た目、操作状態の定義は上流を読み、業務ルール、データ、公開環境は各プロジェクトの正本を使う。共有デザインを導入するときは、利用側の `design.config.json` で採用する版をコミットSHAに固定する。

| 判断すること | 使うパターンと一次資料 | 参照するスキル・コマンド |
| --- | --- | --- |
| 利用者の操作の順番 | 確認して行動する、比較して決める、調査してから行動する、実行して結果を確認する、の中から実際の操作に合う順番を選ぶ。[操作パターンの実装](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/journey.ts) | [目標設定](skills/charter/SKILL.md)・[自律開発](skills/deliver/SKILL.md) |
| 判断に必要な情報と文言 | 利用者が結論、理由、根拠、次の操作を見つけられるようにする。実績、予測、仮説、未確認を表示まで区別する。[共通の判断パネル](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/decision.tsx)・[コンテンツのスキーマ](https://github.com/KAFKA2306/design/blob/main/artifacts/content.schema.json) | [データ設計](skills/schema/SKILL.md)・[文章の推敲](skills/humanizer/SKILL.md) |
| 部品と見た目の正本 | 共通の部品とトークンを使い、同期後の状態を検証する。利用側で同じ値や部品を独立して維持する箇所は、置き換え後に整理する。[設計・同期の手順](https://github.com/KAFKA2306/design/blob/main/skills/frontend-design/SKILL.md#workflow)・[共通トークン](https://github.com/KAFKA2306/design/blob/main/tokens/foundation.tokens.json) | [自律開発](skills/deliver/SKILL.md)・[不要なファイル・コード・文章の削除](skills/prune/SKILL.md) |
| 操作と状態の検証 | 実際に描画された画面で、通常時、読み込み中、空、エラー、利用不可、該当する未確認を区別し、キーボード、タッチ、狭い画面で必要な操作を確かめる。[設計と検証の基準](https://github.com/KAFKA2306/design#current-design-contract) | [反証レビュー](skills/scrutiny/SKILL.md)・[評価と比較](skills/benchmark/SKILL.md) |
| 初見の用途と作業の完了 | 普段の入口で、用途が伝わるかと、目標だけで作業を完了できるかを確かめる。画面や操作を見直すときは[画面評価の手順と記入例](https://github.com/KAFKA2306/design/blob/main/docs/frontend-review.md)を使う。 | [評価と比較](skills/benchmark/SKILL.md)・[目標設定](skills/charter/SKILL.md) |

## ノートの管理

Obsidianでは、このリポジトリのルートを保管庫として開く。文書と見出しは相対Markdownリンクで結ぶ。ファイル名や見出しを変更したら参照元も更新し、GitHubとObsidianの双方でたどれる形にする。

すべてのMarkdownにYAML frontmatterを置く。`type` は文書の種別を示す空でない文字列、`description` は用途を示す空でない日本語の説明、`tags` は空でない検索用リストとする。新規・既存のREADME、記事、スキル、規約も例外にしない。変更時は想定したプロパティ値とタグで文書を検索・抽出できることを確認する。Obsidianを使えない場合はYAMLを解析して同じ条件で検索する。`aliases` は別の名前で探す文書に使う。同じキーの型は保管庫内で統一する。設定ファイルの用途とタグは[作業規約](AGENTS.md#ファイルの管理)に記録する。

タグは小文字とハイフンを使い、階層は `/` で区切る。YAMLでは `kafstyler/canon` と書き、Obsidianでは `tag:#kafstyler/canon` で検索する。

[保管庫](#obsidianの保管庫)・[内部リンク](#obsidianの内部リンク)・[プロパティ](#obsidianのプロパティ)・[タグ](#obsidianのタグ)・[データ設計](skills/schema/SKILL.md)

## 目標・文章・評価

### 登大遊の論理的思考

[登大遊・論理的思考の放棄](https://softether.hatenadiary.org/entry/20070324/p1)（原典）。完成時の利用場面と最初の違和感

[目標設定](skills/charter/SKILL.md)

### Claude Codeの実践

[Anthropic・Claude Codeの実践ガイド](https://code.claude.com/docs/en/best-practices)（公式ガイド）。依頼の範囲、検証、作業の進め方

[目標設定](skills/charter/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### 成功基準と評価

[Anthropic・成功基準と評価の設計](https://platform.claude.com/docs/en/test-and-evaluate/develop-tests)（公式ガイド）。成功条件、テストケース、採点方法

[GOV.UK・利用者テスト](https://www.gov.uk/service-manual/user-research/using-moderated-usability-testing)（公式手引き）。文書、ツール、画面の用途が分かりづらいときは、普段の入口で初見の理解と作業の完了をそれぞれ確かめる。利用者には目標を伝え、手順は伏せる。評価では、対象の版、止まった箇所、観察した事実、利用者への影響、修正後の合格条件を返す。用途を確認できない場合は未確定とし、試せた範囲を伝える。

[評価と比較](skills/benchmark/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md)

### imozの日本語編集

[imoz・日本語の文章編集ガイド](https://imoz.jp/humanizer.ja.txt)（編集ガイド）。人が読む文章の執筆と推敲

[評価と比較](skills/benchmark/SKILL.md) · [自律開発](skills/deliver/SKILL.md) · [データ設計](skills/schema/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md) · [文章の推敲](skills/humanizer/SKILL.md) · [目標設定](skills/charter/SKILL.md) · [不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### 読者から記事を設計する

- [英国国家統計局・Designing content to meet user needs](https://service-manual.ons.gov.uk/content/writing-for-users/user-needs)（公式編集ガイド）。読者が何をしたいかを根拠から把握し、何ができれば記事がその用事に応えたといえるかを執筆前に決める。
- [Nielsen Norman Group・The Layer-Cake Pattern of Scanning Content on the Web](https://www.nngroup.com/articles/layer-cake-pattern-scanning/)（視線計測の研究報告）。見出しを拾い読みして必要な本文を探す行動を踏まえ、見出しだけでも答えの場所を見つけられるかを確かめる。

[文章の推敲](skills/humanizer/SKILL.md#記事を読者から設計する)

### 成果物の根拠と読みやすさ

- [MaryCache・imozuru](https://github.com/MaryCache/imozuru)（公式リポジトリ）。分野の用語、文献、引用をたどり、判断を支える原文の場所を調べる。
- [nanaism・yomiyasu](https://github.com/nanaism/yomiyasu)（公式リポジトリ）。主張と条件を保ち、人が読む日本語を推敲する。

[成果物の確認手順](AGENTS.md#成果物の各要素を根拠と照合する) · [導入手順](README.md#成果物の根拠調査と推敲) · [反証レビュー](skills/scrutiny/SKILL.md#成果物の理由を確かめる)

## エージェントとハーネス

### Claude Agent SDK

[Anthropic・Agent SDK overview](https://code.claude.com/docs/en/agent-sdk)（公式ガイド）。実行場所と必要な機能に応じて方式を選ぶ。

| やりたいこと | 選ぶ方式 |
| --- | --- |
| 自分で運用するPython・TypeScriptアプリにClaude Codeのツール、エージェントループ、セッションを組み込む | Claude Agent SDK |
| 端末で対話して開発する、または単発の処理を実行する | Claude Code CLI |
| Claude APIを直接呼び、ツール処理をアプリ側で組み立てる | Client SDK |
| Anthropicが運用するエージェントの実行基盤をAPIから使う | Claude Managed Agents |

[プラグインの読み込み](https://code.claude.com/docs/en/agent-sdk/plugins)・[ツールの権限設定](https://code.claude.com/docs/en/agent-sdk/permissions)（公式仕様）。[導入と確認](skills/deliver/SKILL.md#claude-agent-sdkでの実装)

### スキルの執筆

[Anthropic・Agent Skills執筆ガイド](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)（公式ガイド）。スキルの記述、検証、手直し

[自律開発](skills/deliver/SKILL.md) · [不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### Claude Codeのスキル

[Anthropic・Claude Code Skills](https://code.claude.com/docs/en/skills)（公式仕様）。スキルの配置と呼び出し

[自律開発](skills/deliver/SKILL.md)

### Claude Codeのコマンド一覧

[Anthropic・Claude Codeのコマンド一覧](https://code.claude.com/docs/en/commands#all-commands)（公式リファレンス）。組み込みコマンド、同梱スキル、ワークフロー、別名との名前の重複を確かめる。

[作業規約](AGENTS.md#ファイルの管理)

### Claude Codeのloop

[Anthropic・Run prompts on a schedule](https://code.claude.com/docs/en/scheduled-tasks#run-a-prompt-repeatedly-with-loop)（公式リファレンス）。`/loop` からのスキルの定期実行、実行条件、ジョブの解除を確認する。

[自律開発の連携手順](skills/deliver/SKILL.md#claude-codeの-loop-連携)

### Claude Codeのフック

[Anthropic・SessionStart](https://code.claude.com/docs/en/hooks#sessionstart)（公式仕様）。起動時に規約を渡す。

[Anthropic・UserPromptSubmit](https://code.claude.com/docs/en/hooks#userpromptsubmit)（公式仕様）。依頼受付時にスキルの発動条件を渡す。

[作業規約](AGENTS.md#全作業への適用と自己改善)

### プラグインの作成

[Anthropic・Claude Codeプラグインの作成](https://code.claude.com/docs/en/plugins/create)（公式ガイド）。プラグインの作成と検証

[自律開発](skills/deliver/SKILL.md)

### Codexのプラグインとフック

- [OpenAI・プラグインの構成](https://developers.openai.com/plugins/build/plugins)（公式仕様）。Codexのマニフェスト、同梱スキル、フックを定義する。
- [OpenAI・Codexのフック](https://learn.chatgpt.com/docs/hooks)（公式仕様）。フックの承認、各イベントの入力と出力、続行条件を確認する。
- [OpenAI・Codexのプラグインコマンド](https://learn.chatgpt.com/docs/developer-commands#codex-plugin)（公式リファレンス）。配布元の登録、インストール、更新に使う。
- [OpenAI・スキルの作成と実行](https://learn.chatgpt.com/docs/build-skills)（公式ガイド）。同梱したスキルの検出と利用方法を確認する。

[作業規約](AGENTS.md#全作業への適用と自己改善)・[導入手順](README.md#codex)

### プラグインの構成

[Anthropic・プラグインの構成要素](https://code.claude.com/docs/en/plugins/components)（公式仕様）。コマンドやスキルの構成

[自律開発](skills/deliver/SKILL.md)

### プラグインのマニフェスト

[Anthropic・プラグインマニフェスト仕様](https://code.claude.com/docs/en/plugins/manifest-reference)（公式仕様）。マニフェストの項目と形式

[自律開発](skills/deliver/SKILL.md)

### DeepSeek Harnessの使い方

[DeepSeek Harness・公式開発者ドキュメント](https://deepseek-harness.github.io/deepseek-harness/)（公式開発者ドキュメント）。DeepSeek Harnessの利用と拡張

[自律開発](skills/deliver/SKILL.md)

### DeepSeek Harnessの構成

[DeepSeek Harness・アーキテクチャ](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/architecture.md)（公式設計文書）。Cordis、プロファイル、バンドルの構成

[自律開発](skills/deliver/SKILL.md)

### エージェントスキルの仕様

[Agent Skills・仕様](https://agentskills.io/specification)（標準仕様）。SKILL.mdの形式、名前と説明、補助資料の配置

[自律開発](skills/deliver/SKILL.md)

### MCPのツール仕様

[Model Context Protocol・Tools](https://modelcontextprotocol.io/specification/latest/server/tools)（標準仕様）。MCPツールの発見、入力スキーマ、呼び出しと結果

[自律開発](skills/deliver/SKILL.md)

### OpenAIのハーネス設計

[OpenAI・Harness engineering](https://openai.com/index/harness-engineering/)（公式技術記事）。エージェントがたどれるリポジトリ構成と検証

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### 長時間稼働するエージェント

[Anthropic・Effective harnesses for long-running agents](https://www.anthropic.com/research/effective-harnesses-for-long-running-agents)（公式技術記事）。長時間作業の引き継ぎと成果の確認

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### OpenAIの現場開発

[OpenAI・現場で成果を届けるエンジニアリング（What FDE means at OpenAI）](https://openai.com/index/forward-deployed-engineering-means/)（開発元の実践記事）。利用者の成果から入り、実際の利用環境で改善を確かめる。

[目標設定](skills/charter/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

## AIエンジニアリングの書籍

### AI Engineering（Chip Huyen）

[Chip Huyen・AI Engineering](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)（書籍）。基盤モデルを使うアプリケーションの設計と評価

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### エージェント設計の書籍

[Manning・Agent Engineering](https://www.manning.com/books/agent-engineering)（書籍）。自律性の設計、ツール連携、評価とフィードバック

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

## データ・オントロジー・命名

### 産業オントロジー

[Industrial Ontologies Foundry・IOF Ontology Portal](https://spec.industrialontologies.org/portal/)（公式ポータル）。産業分野の共通概念と関係

[データ設計](skills/schema/SKILL.md)

### Foundryのオントロジー

[Palantir Foundry・Ontology](https://www.palantir.com/docs/foundry/ontology/overview/)（公式ドキュメント）。業務で扱うオブジェクト、関係、操作

[データ設計](skills/schema/SKILL.md)

### Foundryのデータ来歴

[Palantir Foundry・Data Lineage](https://www.palantir.com/docs/foundry/data-lineage/overview/)（公式ドキュメント）。データの出所と派生先の追跡

[データ設計](skills/schema/SKILL.md)

### スタースキーマ

[Microsoft Learn・スター・スキーマ](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema)（公式ガイド）。ファクトとディメンションの設計

[データ設計](skills/schema/SKILL.md)

### ファクトの粒度

[Kimball Group・ファクトの粒度](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/)（設計原典）。ファクトの1行が何を表すかの定義

[データ設計](skills/schema/SKILL.md)

### 来歴の標準

[W3C・PROV-O 来歴の標準](https://www.w3.org/TR/prov-o/)（標準仕様）。根拠となる実体、活動、主体の関係

[データ設計](skills/schema/SKILL.md)

### データカタログの標準

[W3C・DCAT 3 データカタログの標準](https://www.w3.org/TR/vocab-dcat-3/)（標準仕様）。データセットと配布物の記述

[データ設計](skills/schema/SKILL.md)

### dbtの概要

[dbt Developer Hub・dbtの概要](https://docs.getdbt.com/docs/introduction)（公式ドキュメント）。変換モデルの構成

[データ設計](skills/schema/SKILL.md)

### dbtのソース

[dbt・ソースと来歴](https://docs.getdbt.com/docs/build/sources)（公式ドキュメント）。入力データの定義と来歴

[データ設計](skills/schema/SKILL.md)

### dbtのデータテスト

[dbt・データ品質テスト](https://docs.getdbt.com/docs/build/data-tests)（公式ドキュメント）。データ品質条件の検証

[データ設計](skills/schema/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### 命名規則

[Microsoft・General Naming Conventions](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/general-naming-conventions)（公式ガイド）。.NETの指針から、意味が伝わる語を選び、よく知られた略語だけを使う原則を採用する。

[データ設計](skills/schema/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

## Obsidian

### Obsidianのプロパティ

[Obsidian・Properties](https://obsidian.md/help/properties)（公式ドキュメント）。ファイル先頭のYAML、プロパティの名前と型

[データ設計](skills/schema/SKILL.md)

### Obsidianのタグ

[Obsidian・Tags](https://obsidian.md/help/tags)（公式ドキュメント）。タグのリスト、階層、検索

[データ設計](skills/schema/SKILL.md)

### Obsidianの保管庫

[Obsidian・保管庫の作成](https://obsidian.md/help/vault)（公式文書）。既存フォルダを保管庫として開く。

[データ設計](skills/schema/SKILL.md)

### Obsidianの内部リンク

[Obsidian・内部リンク](https://obsidian.md/help/links)（公式文書）。ノートと見出しを相対Markdownリンクで結ぶ。

[データ設計](skills/schema/SKILL.md)

## CLI・開発・インフラ

### UNIX哲学

[McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](https://doi.org/10.1002/j.1538-7305.1978.tb02135.x)（原典）。一つのプログラムに一つの仕事を任せ、入出力でつなぐ

[自律開発](skills/deliver/SKILL.md) · [不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### Pydanticのデータ検証

[Pydantic・検証の公式ドキュメント](https://pydantic.dev/docs/validation/latest/get-started/)（公式ドキュメント）。データの型と入力値の検証

[データ設計](skills/schema/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### uvの環境管理

[Astral・uv](https://docs.astral.sh/uv/)（公式ドキュメント）。Pythonの環境と依存関係

[自律開発](skills/deliver/SKILL.md)

### Ruffの静的解析

[Astral・Ruff](https://docs.astral.sh/ruff/)（公式ドキュメント）。Pythonのlintと整形

[自律開発](skills/deliver/SKILL.md)

### tyの型検査

[Astral・ty](https://docs.astral.sh/ty/)（公式ドキュメント）。Pythonの型検査

[自律開発](skills/deliver/SKILL.md)

### Pulumiの構成管理

[Pulumi・Infrastructure as Code](https://www.pulumi.com/docs/iac/)（公式ドキュメント）。インフラ構成の実装

[自律開発](skills/deliver/SKILL.md)

### Pulumiの差分確認

[Pulumi・変更の事前確認（pulumi preview）](https://www.pulumi.com/docs/iac/cli/commands/pulumi_preview/)（公式手順）。インフラ変更の適用前確認

[自律開発](skills/deliver/SKILL.md)

## UIとComfyUI

### Googleの画面設計

[Google Gemini・DemoLabのフロントエンド設計スキル](https://github.com/google-gemini/demolab#installation)（公式スキル）。フロントエンド設計

[自律開発](skills/deliver/SKILL.md)

### ComfyUIの公式文書

[ComfyUI・公式ドキュメント](https://docs.comfy.org/)（公式ドキュメント）。ComfyUIの基本操作

[自律開発](skills/deliver/SKILL.md)

### ComfyUIのワークフロー選定

[ComfyUI Workflow選定と採用の基準](https://github.com/KAFKA2306/comfyui-workflows-factory/blob/main/docs/knowledge/best-workflows.md)（制作の選定基準）。8領域の第一候補、代替、原典、採用前に確かめる条件

[自律開発](skills/deliver/SKILL.md)

### ComfyUIのテンプレート

[ComfyUI・Workflow Templatesの使い方](https://docs.comfy.org/interface/features/template)（公式手順）。テンプレートの選び方と実行

[自律開発](skills/deliver/SKILL.md)

### ComfyUIのテンプレート正本

[ComfyUI・公式テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)（公式実装）。テンプレートの取得元

[自律開発](skills/deliver/SKILL.md)

### ComfyUIのワークフロー形式

[ComfyUI・Workflow JSON仕様原本](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx)（公式仕様）。ワークフローのJSON形式

[自律開発](skills/deliver/SKILL.md)

## ユニティとVRChatの制作ツール

用途ごとに1本を選定。Starsは2026-11-17にGitHubで取得した値。

### ユニティの汎用MCP

[汎用Unity・CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp)（開発元実装）。シーン、アセット、テスト、ビルドを扱う50のMCPツール。MIT。GitHub Stars 16,030。

[自律開発](skills/deliver/SKILL.md)

### VRChatのワールド制作

[VRChat Worlds・swax/UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC)（開発元実装）。UdonSharpの補助とエディター画面の確認。GitHub Stars 73。CC BY-NC 4.0のため、BOOTH向けなどの商用制作では利用条件を事前に確認する。[ライセンス原文](https://github.com/swax/UnityMCP-VRC/blob/main/LICENSE)

[自律開発](skills/deliver/SKILL.md)

### VRChatのアバター制作

[VRChat Avatars・lighfu/unity-agent](https://github.com/lighfu/unity-agent)（開発元実装）。READMEに400以上の操作ツールとComfyUI連携を記載。Avatar Descriptorの検査、PhysBoneの設定、Modular Avatarによる衣装導入、SDKビルドとアップロードを扱う。MIT。GitHub Stars 45。[衣装導入手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md)・[SDKビルド手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md)

[自律開発](skills/deliver/SKILL.md)

## Tripoと3D生成

### Tripo Studio

[Tripo Studio・公式ドキュメント](https://www.tripo3d.ai/product-doc)（公式ドキュメント）。Studioでの制作

[自律開発](skills/deliver/SKILL.md)

### TripoのAPI

[Tripo API・公式ドキュメント](https://developers.tripo3d.ai/en/docs/introduction)（公式ドキュメント）。APIを使った生成処理

[自律開発](skills/deliver/SKILL.md)

### TripoのComfyUI連携

[Tripo・ComfyUIノードの公式ドキュメント](https://developers.tripo3d.ai/en/docs/comfyui-nodes)（公式ドキュメント）。ComfyUIでのノード設定

[自律開発](skills/deliver/SKILL.md)

### Tripoの研究一覧

[Tripo / VAST AI・論文一覧](https://www.tripo3d.ai/research/publications)（論文一覧）。関連する手法の検索

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### 画像からの三次元復元

[TripoSR・単一画像からの3D復元](https://arxiv.org/abs/2403.02151)（技術報告）。単一画像からの3D復元

[評価と比較](skills/benchmark/SKILL.md)

### 細部を保つ三次元形状生成

[TripoSG・高精細な3D形状生成](https://arxiv.org/abs/2502.06608)（論文）。3D形状の生成と品質評価

[評価と比較](skills/benchmark/SKILL.md)

### 任意のトポロジーを持つ形状

[SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](https://arxiv.org/abs/2503.21732)（論文）。任意のトポロジーを持つ形状の表現

[評価と比較](skills/benchmark/SKILL.md)

### 密度を制御する三次元生成

[TripoSplat・密度を制御する3Dガウシアン生成](https://arxiv.org/abs/2605.16355)（論文）。密度を制御する3Dガウシアン生成

[評価と比較](skills/benchmark/SKILL.md)

### 動かせる三次元アセット

[AniGen・アニメーション可能な3Dアセット生成](https://arxiv.org/abs/2604.08746)（論文）。アニメーション可能な3Dアセット生成

[評価と比較](skills/benchmark/SKILL.md)

### 頂点とトポロジーを扱うメッシュ生成

[Nexus・頂点とトポロジーを扱うメッシュ生成](https://doi.org/10.1145/3811344)（論文）。頂点とトポロジーを扱うメッシュ生成

[評価と比較](skills/benchmark/SKILL.md)

## かふかのZenn

### かふかのZenn記事一覧

[かふかのZenn記事一覧](https://zenn.dev/kafka2306?tab=articles)（記事一覧）。対象の作業に近い記事を探す。

[評価と比較](skills/benchmark/SKILL.md) · [自律開発](skills/deliver/SKILL.md) · [データ設計](skills/schema/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md) · [文章の推敲](skills/humanizer/SKILL.md) · [目標設定](skills/charter/SKILL.md) · [不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### AIが増やす判断箇所

[かふか「なぜAIに任せるほど、あなたのコードは複雑になるのか」](https://zenn.dev/kafka2306/articles/2026-08-16-ai-added-decision-cost-audit)（記事）。分岐や状態の重複を見つけ、統合や削除の優先順位を決める。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### Issue駆動開発

[AIに同じ指示を繰り返すのをやめた。Issue駆動開発という最小運用](https://zenn.dev/kafka2306/articles/issue-driven-development)（記事）。終わった変更の経緯をIssueに残し、現在の仕様として必要な記述を正本に集約する。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### 失敗原因が見える実装

[AIを「過保護」にするな。スタックトレースを聖典とする開発規律 "Crash-Driven Development"](https://zenn.dev/kafka2306/articles/11cd731eebded1)（記事）。障害の原因を隠す広すぎる例外捕捉やフォールバックを見直し、根本原因を観測できる形にする。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### 個人開発の次の一件

[個人開発が123個になって分かった。ChatGPTに任せるべきはコードより「次の1件」だった](https://zenn.dev/kafka2306/articles/chatgpt-multiproject-autonomy)（記事）。複数プロジェクトから次の変更を選び、利用者に届いたかを確認する。

[目標設定](skills/charter/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### 自動テストの合格条件

[Claude Codeにテストを全部任せるなら、先に「合格条件」を固定する](https://zenn.dev/kafka2306/articles/2026-08-15-hook-runner-is-not-policy)（記事）。実装に着手する前に、期待出力と合否条件を固定する。

[評価と比較](skills/benchmark/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### 外部実装の互換性と判定根拠

[OSSが動いた。でもその判定はまだ使えない。「動く」と「使ってよい」を4状態に分ける](https://zenn.dev/kafka2306/articles/2026-08-14-05-compatibility-is-not-validation)（記事）。動作・入力条件・証拠を別々に確かめ、判定に使える範囲を定める。

[評価と比較](skills/benchmark/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md)

### 成果物を仕事の証拠にする

[人は他人を『何を任せられるか』で圧縮する——成果物が仕事の証拠になるまで](https://zenn.dev/kafka2306/articles/2026-08-13-02-how-people-compress-a-person)（記事）。担当できる課題と得られる結果を成果物で示す。

[目標設定](skills/charter/SKILL.md) · [文章の推敲](skills/humanizer/SKILL.md)

### 透かしの検証可能性

[AIの文章に「透かし」があると言われたら、誰がそれを証明できるのか](https://zenn.dev/kafka2306/articles/claude-watermark-secret-key-detection)（記事）。検証主体と公開根拠を確かめ、一次資料で前提を見直す。

[反証レビュー](skills/scrutiny/SKILL.md)

### AI検索向けの一次情報

[AI検索最適化（GEO/AEO）運用指針](https://zenn.dev/kafka2306/articles/6dd453d941b99f)（記事）。公開物の一次情報、機械可読性、施策の検証条件を確認する。

[文章の推敲](skills/humanizer/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md)

### 目的別の情報収集サイト

[AI活用してそうな情報サイトのクオリティがすごい](https://zenn.dev/kafka2306/articles/1436dad81ab3ac)（記事）。調べたい項目から企業史、財務、IRなどの候補を探し、原典へたどる。

[反証レビュー](skills/scrutiny/SKILL.md)

### 継続検証による技術監査

[Adaptive Survivable Verification System (ASVS) に基づく技術監査フレームワーク](https://zenn.dev/kafka2306/articles/5c3c93f798da3f)（記事）。実行時の変化を観測し、検証で用いる証拠を定める。

[評価と比較](skills/benchmark/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md)

### 完了を裏づける証拠

[AIの“やったふり”とハルシネーションを暴くゼロトラスト・コントラクト](https://zenn.dev/kafka2306/articles/77e6af7be1d527)（記事）。完了報告を実行結果や再現できる証拠と照らす。

[評価と比較](skills/benchmark/SKILL.md) · [反証レビュー](skills/scrutiny/SKILL.md)

### エージェント向けのフォルダ整理

[AIエージェントのためのディレクトリ管理指針 — モデルを邪魔しない構造設計](https://zenn.dev/kafka2306/articles/5c21f4d010baeb)（記事）。指示や過去の生成物を仕分け、作業に使う情報へ短く到達できる配置にする。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md)

### WindowsでのGemini CLI導入

[WindowsでDocker×Gemini CLI×everything-claude-code Skillsを一気に動かす](https://zenn.dev/kafka2306/articles/cd6f21d4a26bdd)（記事）。WindowsでDocker、Gemini CLI、スキルを組み合わせる手順を参照する。

[自律開発](skills/deliver/SKILL.md)

### エージェント向け運用基盤

[AIエージェントのためのインフラ：agent-resources (agr) の設計思想](https://zenn.dev/kafka2306/articles/9f9997babac335)（記事）。機能を個別プロジェクトに持たせるか、共通ツールを使うかの判断材料にする。

[自律開発](skills/deliver/SKILL.md)

### AstralのPython開発基盤

[Astral ツールチェーンで作る 2026 年の Python 開発基盤：uv から次世代型チェッカー ty まで](https://zenn.dev/kafka2306/articles/2005501fe91754)（記事）。Pythonの依存管理、型検査、静的解析を既存ツールに委ねる方法を参照する。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### SteamVRの起動障害

[【SteamVR】PicoConnect削除後に起動しない・HMD未検出になる時の修復手順](https://zenn.dev/kafka2306/articles/a25478878eeaab)（記事）。起動と機器認識が止まった操作を切り分け、復旧後に同じ経路を試す。

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### WSL2でのAntigravity導入

[WSL2でLinuxネイティブ版Antigravityを正しく動かす](https://zenn.dev/kafka2306/articles/09834f9c98002d)（記事）。Windows版とLinux版の実行ファイルを区別し、起動元を確かめる。

[自律開発](skills/deliver/SKILL.md)

### Taskで共通の実行手順を作る

[開発者とAIのための「共通の作法」をつくる Task](https://zenn.dev/kafka2306/articles/215f0d6521e498)（記事）。手順を書き写す箇所を減らし、Taskfileで人とAIが同じ入口を使う。

[不要なファイル・コード・文章の削除](skills/prune/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### WindowsとWSLの自動化

[Windows × WSL 自動化の正解](https://zenn.dev/kafka2306/articles/18fe96f422c920)（記事）。実行ユーザー、パス、起動元が変わる境界で自動化を確認する。

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)

### WSL2でのUnity Hub導入

[WSL2でUnity Hubをインストールする方法](https://zenn.dev/kafka2306/articles/5ef689985e9aee)（記事）。WSL2でUnity Hubとエディターを用意する際の手順を参照する。

[自律開発](skills/deliver/SKILL.md)

## ISUCONのハーネス

### ISUCONの準備

[ISUCON2026 で優勝しました（準備編）](https://zenn.dev/luvtechno/articles/isucon2026-preparation)（当事者の実践記録）。素の構成を先に測り、追加した知識や道具の効果を同じ課題で比較する。

[評価と比較](skills/benchmark/SKILL.md) · [自律開発](skills/deliver/SKILL.md)

### ISUCONの優勝ハーネス

[fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](https://fukabori.fm/episode/142)（当事者インタビュー）。長時間の自律実行、競技用ハーネスを小さくした経緯、計測と停止の判断を参照する。

[自律開発](skills/deliver/SKILL.md) · [評価と比較](skills/benchmark/SKILL.md)
