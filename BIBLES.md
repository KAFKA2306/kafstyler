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

## ノートの管理

Obsidianでは、このリポジトリのルートを保管庫として開く。文書と見出しは相対Markdownリンクで結ぶ。ファイル名や見出しを変更したら参照元も更新し、GitHubとObsidianの双方でたどれる形にする。

すべてのMarkdownにYAMLのfrontmatterを置く。 `type` は文書の種別、 `description` は用途を示す日本語の説明、 `tags` は検索用のリストとする。 `aliases` は別の名前で探す文書に使う。同じキーの型は保管庫内で統一する。設定ファイルの用途とタグは[作業規約](AGENTS.md#ファイルの管理)に記録する。

タグは小文字とハイフンを使い、階層は `/` で区切る。YAMLでは `kafstyler/canon` と書き、Obsidianでは `tag:#kafstyler/canon` で検索する。

[保管庫](#obsidianの保管庫)・[内部リンク](#obsidianの内部リンク)・[プロパティ](#obsidianのプロパティ)・[タグ](#obsidianのタグ)・[データ設計](skills/data/SKILL.md)

## 目標・文章・評価

### 登大遊の論理的思考

[登大遊・論理的思考の放棄](https://softether.hatenadiary.org/entry/20070324/p1)（原典）。完成時の利用場面と最初の違和感

[目標設定](skills/scope/SKILL.md)

### claude-codeの実践

[Anthropic・Claude Codeの実践ガイド](https://code.claude.com/docs/en/best-practices)（公式ガイド）。依頼の範囲、検証、作業の進め方

[目標設定](skills/scope/SKILL.md) · [自律開発](skills/build/SKILL.md)

### 成功基準と評価

[Anthropic・成功基準と評価の設計](https://platform.claude.com/docs/en/test-and-evaluate/develop-tests)（公式ガイド）。成功条件、テストケース、採点方法

[自動評価](skills/test/SKILL.md) · [対立仮説](skills/critique/SKILL.md)

### imozの日本語編集

[imoz・日本語の文章編集ガイド](https://imoz.jp/humanizer.ja.txt)（編集ガイド）。任意の出力に含まれる人向け文章の執筆と校正

[自動評価](skills/test/SKILL.md) · [自律開発](skills/build/SKILL.md) · [データ設計](skills/data/SKILL.md) · [致命的な欠陥のレビュー](skills/critique/SKILL.md) · [文書校正](skills/edit/SKILL.md) · [目標設定](skills/scope/SKILL.md) · [AIスロップ削除](skills/clean/SKILL.md)

## エージェントとハーネス

### スキルの執筆

[Anthropic・Agent Skills執筆ガイド](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)（公式ガイド）。スキルの記述、検証、手直し

[自律開発](skills/build/SKILL.md) · [AIスロップ削除](skills/clean/SKILL.md)

### claude-codeのスキル

[Anthropic・Claude Code Skills](https://code.claude.com/docs/en/skills)（公式仕様）。スキルの配置と呼び出し

[自律開発](skills/build/SKILL.md)

### Claude Codeのコマンド一覧

[Anthropic・Claude Codeのコマンド一覧](https://code.claude.com/docs/en/commands#all-commands)（公式リファレンス）。組み込みコマンド、同梱スキル、ワークフロー、別名との名前の重複を確かめる。

[作業規約](AGENTS.md#ファイルの管理)

### Claude Codeの依頼受付フック

[Anthropic・UserPromptSubmit](https://code.claude.com/docs/en/hooks#userpromptsubmit)（公式仕様）。依頼送信時に作業規約を適用するためのフック。

[作業規約](AGENTS.md#全作業への適用と自己改善)

### プラグインの作成

[Anthropic・Claude Codeプラグインの作成](https://code.claude.com/docs/en/plugins/create)（公式ガイド）。プラグインの作成と検証

[自律開発](skills/build/SKILL.md)

### プラグインの構成

[Anthropic・プラグインの構成要素](https://code.claude.com/docs/en/plugins/components)（公式仕様）。コマンドやスキルの構成

[自律開発](skills/build/SKILL.md)

### プラグインのマニフェスト

[Anthropic・プラグインマニフェスト仕様](https://code.claude.com/docs/en/plugins/manifest-reference)（公式仕様）。マニフェストの項目と形式

[自律開発](skills/build/SKILL.md)

### deepseek-harnessの使い方

[DeepSeek Harness・公式開発者ドキュメント](https://deepseek-harness.github.io/deepseek-harness/)（公式開発者ドキュメント）。DeepSeek Harnessの利用と拡張

[自律開発](skills/build/SKILL.md)

### deepseek-harnessの構成

[DeepSeek Harness・アーキテクチャ](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/architecture.md)（公式設計文書）。Cordis、プロファイル、バンドルの構成

[自律開発](skills/build/SKILL.md)

### エージェントスキルの仕様

[Agent Skills・仕様](https://agentskills.io/specification)（標準仕様）。SKILL.mdの形式、名前と説明、補助資料の配置

[自律開発](skills/build/SKILL.md)

### mcpのツール仕様

[Model Context Protocol・Tools](https://modelcontextprotocol.io/specification/latest/server/tools)（標準仕様）。MCPツールの発見、入力スキーマ、呼び出しと結果

[自律開発](skills/build/SKILL.md)

### openaiのハーネス設計

[OpenAI・Harness engineering](https://openai.com/index/harness-engineering/)（公式技術記事）。エージェントがたどれるリポジトリ構成と検証

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### 長時間稼働するエージェント

[Anthropic・Effective harnesses for long-running agents](https://www.anthropic.com/research/effective-harnesses-for-long-running-agents)（公式技術記事）。長時間作業の引き継ぎと成果の確認

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### openaiの現場開発

[OpenAI・現場で成果を届けるエンジニアリング（What FDE means at OpenAI）](https://openai.com/index/forward-deployed-engineering-means/)（開発元の実践記事）。利用者の成果から入り、実際の利用環境で改善を確かめる。

[目標設定](skills/scope/SKILL.md) · [自律開発](skills/build/SKILL.md)

## AIエンジニアリングの書籍

### aiエンジニアリングの書籍

[Chip Huyen・AI Engineering](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)（書籍）。基盤モデルを使うアプリケーションの設計と評価

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### エージェント設計の書籍

[Manning・Agent Engineering](https://www.manning.com/books/agent-engineering)（書籍）。自律性の設計、ツール連携、評価とフィードバック

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

## データ・オントロジー・命名

### 産業オントロジー

[Industrial Ontologies Foundry・IOF Ontology Portal](https://spec.industrialontologies.org/portal/)（公式ポータル）。産業分野の共通概念と関係

[データ設計](skills/data/SKILL.md)

### foundryのオントロジー

[Palantir Foundry・Ontology](https://www.palantir.com/docs/foundry/ontology/overview/)（公式ドキュメント）。業務で扱うオブジェクト、関係、操作

[データ設計](skills/data/SKILL.md)

### foundryのデータ来歴

[Palantir Foundry・Data Lineage](https://www.palantir.com/docs/foundry/data-lineage/overview/)（公式ドキュメント）。データの出所と派生先の追跡

[データ設計](skills/data/SKILL.md)

### スタースキーマ

[Microsoft Learn・スター・スキーマ](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema)（公式ガイド）。ファクトとディメンションの設計

[データ設計](skills/data/SKILL.md)

### ファクトの粒度

[Kimball Group・ファクトの粒度](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/)（設計原典）。ファクトの1行が何を表すかの定義

[データ設計](skills/data/SKILL.md)

### 来歴の標準

[W3C・PROV-O 来歴の標準](https://www.w3.org/TR/prov-o/)（標準仕様）。根拠となる実体、活動、主体の関係

[データ設計](skills/data/SKILL.md)

### データカタログの標準

[W3C・DCAT 3 データカタログの標準](https://www.w3.org/TR/vocab-dcat-3/)（標準仕様）。データセットと配布物の記述

[データ設計](skills/data/SKILL.md)

### dbtの概要

[dbt Developer Hub・dbtの概要](https://docs.getdbt.com/docs/introduction)（公式ドキュメント）。変換モデルの構成

[データ設計](skills/data/SKILL.md)

### dbtのソース

[dbt・ソースと来歴](https://docs.getdbt.com/docs/build/sources)（公式ドキュメント）。入力データの定義と来歴

[データ設計](skills/data/SKILL.md)

### dbtのデータテスト

[dbt・データ品質テスト](https://docs.getdbt.com/docs/build/data-tests)（公式ドキュメント）。データ品質条件の検証

[データ設計](skills/data/SKILL.md) · [自動評価](skills/test/SKILL.md)

### 命名規則

[Microsoft・General Naming Conventions](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/general-naming-conventions)（公式ガイド）。.NETの指針から、意味が伝わる語を選び、よく知られた略語だけを使う原則を採用する。

[データ設計](skills/data/SKILL.md) · [自律開発](skills/build/SKILL.md)

## Obsidian

### obsidianのプロパティ

[Obsidian・Properties](https://obsidian.md/help/properties)（公式ドキュメント）。ファイル先頭のYAML、プロパティの名前と型

[データ設計](skills/data/SKILL.md)

### obsidianのタグ

[Obsidian・Tags](https://obsidian.md/help/tags)（公式ドキュメント）。タグのリスト、階層、検索

[データ設計](skills/data/SKILL.md)

### obsidianの保管庫

[Obsidian・保管庫の作成](https://obsidian.md/help/vault)（公式文書）。既存フォルダを保管庫として開く。

[データ設計](skills/data/SKILL.md)

### obsidianの内部リンク

[Obsidian・内部リンク](https://obsidian.md/help/links)（公式文書）。ノートと見出しを相対Markdownリンクで結ぶ。

[データ設計](skills/data/SKILL.md)

## CLI・開発・インフラ

### unix哲学

[McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](https://doi.org/10.1002/j.1538-7305.1978.tb02135.x)（原典）。一つのプログラムに一つの仕事を任せ、入出力でつなぐ

[自律開発](skills/build/SKILL.md) · [AIスロップ削除](skills/clean/SKILL.md)

### pydanticのデータ検証

[Pydantic・検証の公式ドキュメント](https://pydantic.dev/docs/validation/latest/get-started/)（公式ドキュメント）。データの型と入力値の検証

[データ設計](skills/data/SKILL.md) · [自律開発](skills/build/SKILL.md)

### uvの環境管理

[Astral・uv](https://docs.astral.sh/uv/)（公式ドキュメント）。Pythonの環境と依存関係

[自律開発](skills/build/SKILL.md)

### ruffの静的解析

[Astral・Ruff](https://docs.astral.sh/ruff/)（公式ドキュメント）。Pythonのlintと整形

[自律開発](skills/build/SKILL.md)

### tyの型検査

[Astral・ty](https://docs.astral.sh/ty/)（公式ドキュメント）。Pythonの型検査

[自律開発](skills/build/SKILL.md)

### pulumiの構成管理

[Pulumi・Infrastructure as Code](https://www.pulumi.com/docs/iac/)（公式ドキュメント）。インフラ構成の実装

[自律開発](skills/build/SKILL.md)

### pulumiの差分確認

[Pulumi・変更の事前確認（pulumi preview）](https://www.pulumi.com/docs/iac/cli/commands/pulumi_preview/)（公式手順）。インフラ変更の適用前確認

[自律開発](skills/build/SKILL.md)

## UIとComfyUI

### googleの画面設計

[Google Gemini・DemoLabのフロントエンド設計スキル](https://github.com/google-gemini/demolab#installation)（公式スキル）。フロントエンド設計

[自律開発](skills/build/SKILL.md)

### comfyuiの公式文書

[ComfyUI・公式ドキュメント](https://docs.comfy.org/)（公式ドキュメント）。ComfyUIの基本操作

[自律開発](skills/build/SKILL.md)

### comfyuiのテンプレート

[ComfyUI・Workflow Templatesの使い方](https://docs.comfy.org/interface/features/template)（公式手順）。テンプレートの選び方と実行

[自律開発](skills/build/SKILL.md)

### comfyuiのテンプレート正本

[ComfyUI・公式テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)（公式実装）。テンプレートの取得元

[自律開発](skills/build/SKILL.md)

### comfyuiのワークフロー形式

[ComfyUI・Workflow JSON仕様原本](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx)（公式仕様）。ワークフローのJSON形式

[自律開発](skills/build/SKILL.md)

## ユニティとvrchatの制作ツール

用途ごとに1本を選定。Starsは2026-11-17にGitHubで取得した値。

### ユニティの汎用mcp

[汎用Unity・CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp)（開発元実装）。シーン、アセット、テスト、ビルドを扱う50のMCPツール。MIT。GitHub Stars 16,030。

[自律開発](skills/build/SKILL.md)

### vrchatのワールド制作

[VRChat Worlds・swax/UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC)（開発元実装）。UdonSharpの補助とエディター画面の確認。GitHub Stars 73。CC BY-NC 4.0のため、BOOTH向けなどの商用制作では利用条件を事前に確認する。[ライセンス原文](https://github.com/swax/UnityMCP-VRC/blob/main/LICENSE)

[自律開発](skills/build/SKILL.md)

### vrchatのアバター制作

[VRChat Avatars・lighfu/unity-agent](https://github.com/lighfu/unity-agent)（開発元実装）。READMEに400以上の操作ツールとComfyUI連携を記載。Avatar Descriptorの検査、PhysBoneの設定、Modular Avatarによる衣装導入、SDKビルドとアップロードを扱う。MIT。GitHub Stars 45。[衣装導入手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md)・[SDKビルド手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md)

[自律開発](skills/build/SKILL.md)

## Tripoと3D生成

### tripo-studio

[Tripo Studio・公式ドキュメント](https://www.tripo3d.ai/product-doc)（公式ドキュメント）。Studioでの制作

[自律開発](skills/build/SKILL.md)

### tripoのapi

[Tripo API・公式ドキュメント](https://developers.tripo3d.ai/en/docs/introduction)（公式ドキュメント）。APIを使った生成処理

[自律開発](skills/build/SKILL.md)

### tripoのcomfyui連携

[Tripo・ComfyUIノードの公式ドキュメント](https://developers.tripo3d.ai/en/docs/comfyui-nodes)（公式ドキュメント）。ComfyUIでのノード設定

[自律開発](skills/build/SKILL.md)

### tripoの研究一覧

[Tripo / VAST AI・論文一覧](https://www.tripo3d.ai/research/publications)（論文一覧）。関連する手法の検索

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### 画像からの三次元復元

[TripoSR・単一画像からの3D復元](https://arxiv.org/abs/2403.02151)（技術報告）。単一画像からの3D復元

[自動評価](skills/test/SKILL.md)

### 細部を保つ三次元形状生成

[TripoSG・高精細な3D形状生成](https://arxiv.org/abs/2502.06608)（論文）。3D形状の生成と品質評価

[自動評価](skills/test/SKILL.md)

### 任意のトポロジーを持つ形状

[SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](https://arxiv.org/abs/2503.21732)（論文）。任意のトポロジーを持つ形状の表現

[自動評価](skills/test/SKILL.md)

### 密度を制御する三次元生成

[TripoSplat・密度を制御する3Dガウシアン生成](https://arxiv.org/abs/2605.16355)（論文）。密度を制御する3Dガウシアン生成

[自動評価](skills/test/SKILL.md)

### 動かせる三次元アセット

[AniGen・アニメーション可能な3Dアセット生成](https://arxiv.org/abs/2604.08746)（論文）。アニメーション可能な3Dアセット生成

[自動評価](skills/test/SKILL.md)

### 頂点とトポロジーを扱うメッシュ生成

[Nexus・頂点とトポロジーを扱うメッシュ生成](https://doi.org/10.1145/3811344)（論文）。頂点とトポロジーを扱うメッシュ生成

[自動評価](skills/test/SKILL.md)

## かふかのZenn

### かふかのzenn記事一覧

[かふかのZenn記事一覧](https://zenn.dev/kafka2306?tab=articles)（記事一覧）。2026年11月17日に[公式RSS](https://zenn.dev/kafka2306/feed?all=1)と[公開記事一覧API](https://zenn.dev/api/articles?username=kafka2306&order=latest&count=100)を照合し、25件の題名とURLが一致した。一覧APIの次ページはない。

[自動評価](skills/test/SKILL.md) · [自律開発](skills/build/SKILL.md) · [データ設計](skills/data/SKILL.md) · [対立仮説](skills/critique/SKILL.md) · [文書校正](skills/edit/SKILL.md) · [目標設定](skills/scope/SKILL.md) · [AIスロップ削除](skills/clean/SKILL.md)

### aiが増やす判断箇所

[かふか「なぜAIに任せるほど、あなたのコードは複雑になるのか」](https://zenn.dev/kafka2306/articles/2026-08-16-ai-added-decision-cost-audit)（記事）。分岐や状態の重複を見つけ、統合や削除の優先順位を決める。

[AIスロップ削除](skills/clean/SKILL.md)

### issue駆動開発

[AIに同じ指示を繰り返すのをやめた。Issue駆動開発という最小運用](https://zenn.dev/kafka2306/articles/issue-driven-development)（記事）。終わった変更の経緯をIssueに残し、現在の仕様として必要な記述を正本に集約する。

[AIスロップ削除](skills/clean/SKILL.md) · [自律開発](skills/build/SKILL.md)

### 失敗原因が見える実装

[AIを「過保護」にするな。スタックトレースを聖典とする開発規律 "Crash-Driven Development"](https://zenn.dev/kafka2306/articles/11cd731eebded1)（記事）。障害の原因を隠す広すぎる例外捕捉やフォールバックを見直し、根本原因を観測できる形にする。

[AIスロップ削除](skills/clean/SKILL.md)

### ムチォの体験設計

[AIキャラクターは、賢いほど面白いのか？――ムチォがひっくり返した「知能」の価値](https://zenn.dev/kafka2306/articles/2026-08-15-ai-character-intelligence-muchio)（記事）。AIの性能と利用者がキャラクターに求める体験を切り分け、評価対象を定める。

[目標設定](skills/scope/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### 個人開発の次の一件

[個人開発が123個になって分かった。ChatGPTに任せるべきはコードより「次の1件」だった](https://zenn.dev/kafka2306/articles/chatgpt-multiproject-autonomy)（記事）。複数プロジェクトから次の変更を選び、利用者に届いたかを確認する。

[目標設定](skills/scope/SKILL.md) · [自律開発](skills/build/SKILL.md)

### 自動テストの合格条件

[Claude Codeにテストを全部任せるなら、先に「合格条件」を固定する](https://zenn.dev/kafka2306/articles/2026-08-15-hook-runner-is-not-policy)（記事）。実装に着手する前に、期待出力と合否条件を固定する。

[自動評価](skills/test/SKILL.md) · [自律開発](skills/build/SKILL.md)

### 外部実装の互換性と判定根拠

[OSSが動いた。でもその判定はまだ使えない。「動く」と「使ってよい」を4状態に分ける](https://zenn.dev/kafka2306/articles/2026-08-14-05-compatibility-is-not-validation)（記事）。動作・入力条件・証拠を別々に確かめ、判定に使える範囲を定める。

[自動評価](skills/test/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### 成果物を仕事の証拠にする

[人は他人を『何を任せられるか』で圧縮する——成果物が仕事の証拠になるまで](https://zenn.dev/kafka2306/articles/2026-08-13-02-how-people-compress-a-person)（記事）。担当できる課題と得られる結果を成果物で示す。

[目標設定](skills/scope/SKILL.md) · [文書校正](skills/edit/SKILL.md)

### 透かしの検証可能性

[AIの文章に「透かし」があると言われたら、誰がそれを証明できるのか](https://zenn.dev/kafka2306/articles/claude-watermark-secret-key-detection)（記事）。検証主体と公開根拠を確かめ、一次資料で前提を見直す。

[反証レビュー](skills/critique/SKILL.md)

### ai検索向けの一次情報

[AI検索最適化（GEO/AEO）運用指針](https://zenn.dev/kafka2306/articles/6dd453d941b99f)（記事）。公開物の一次情報、機械可読性、施策の検証条件を確認する。

[文書校正](skills/edit/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### 目的別の情報収集サイト

[AI活用してそうな情報サイトのクオリティがすごい](https://zenn.dev/kafka2306/articles/1436dad81ab3ac)（記事）。調べたい項目から企業史、財務、IRなどの候補を探し、原典へたどる。

[反証レビュー](skills/critique/SKILL.md)

### 継続検証による技術監査

[Adaptive Survivable Verification System (ASVS) に基づく技術監査フレームワーク](https://zenn.dev/kafka2306/articles/5c3c93f798da3f)（記事）。実行時の変化を観測し、検証で用いる証拠を定める。

[自動評価](skills/test/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### 完了を裏づける証拠

[AIの“やったふり”とハルシネーションを暴くゼロトラスト・コントラクト](https://zenn.dev/kafka2306/articles/77e6af7be1d527)（記事）。完了報告を実行結果や再現できる証拠と照らす。

[自動評価](skills/test/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### エージェント向けのフォルダ整理

[AIエージェントのためのディレクトリ管理指針 — モデルを邪魔しない構造設計](https://zenn.dev/kafka2306/articles/5c21f4d010baeb)（記事）。指示や過去の生成物を仕分け、作業に使う情報へ短く到達できる配置にする。

[AIスロップ削除](skills/clean/SKILL.md)

### windowsでのgemini-cli導入

[WindowsでDocker×Gemini CLI×everything-claude-code Skillsを一気に動かす](https://zenn.dev/kafka2306/articles/cd6f21d4a26bdd)（記事）。WindowsでDocker、Gemini CLI、スキルを組み合わせる手順を参照する。

[自律開発](skills/build/SKILL.md)

### エージェント向け運用基盤

[AIエージェントのためのインフラ：agent-resources (agr) の設計思想](https://zenn.dev/kafka2306/articles/9f9997babac335)（記事）。機能を個別プロジェクトに持たせるか、共通ツールを使うかの判断材料にする。

[自律開発](skills/build/SKILL.md)

### 市場研究から執行までの設計

[自律型エージェント・アルファ探索＆執行システム「AAARTS」：市場に適応し続ける「自律型知能」](https://zenn.dev/kafka2306/articles/c599b0556555a7)（記事）。探索、検証、執行を分け、各段階の入力と成否の根拠を整理する。

[データ設計](skills/data/SKILL.md) · [反証レビュー](skills/critique/SKILL.md)

### astralのpython開発基盤

[Astral ツールチェーンで作る 2026 年の Python 開発基盤：uv から次世代型チェッカー ty まで](https://zenn.dev/kafka2306/articles/2005501fe91754)（記事）。Pythonの依存管理、型検査、静的解析を既存ツールに委ねる方法を参照する。

[AIスロップ削除](skills/clean/SKILL.md) · [自律開発](skills/build/SKILL.md)

### steamvrの起動障害

[【SteamVR】PicoConnect削除後に起動しない・HMD未検出になる時の修復手順](https://zenn.dev/kafka2306/articles/a25478878eeaab)（記事）。起動と機器認識が止まった操作を切り分け、復旧後に同じ経路を試す。

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### wsl2でのantigravity導入

[WSL2でLinuxネイティブ版Antigravityを正しく動かす](https://zenn.dev/kafka2306/articles/09834f9c98002d)（記事）。Windows版とLinux版の実行ファイルを区別し、起動元を確かめる。

[自律開発](skills/build/SKILL.md)

### taskで共通の実行手順を作る

[開発者とAIのための「共通の作法」をつくる Task](https://zenn.dev/kafka2306/articles/215f0d6521e498)（記事）。手順を書き写す箇所を減らし、Taskfileで人とAIが同じ入口を使う。

[AIスロップ削除](skills/clean/SKILL.md) · [自律開発](skills/build/SKILL.md)

### windowsとwslの自動化

[Windows × WSL 自動化の正解](https://zenn.dev/kafka2306/articles/18fe96f422c920)（記事）。実行ユーザー、パス、起動元が変わる境界で自動化を確認する。

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)

### アプリの責任範囲を分ける

[アプリ設計の正体 ― なぜ分ける？なぜ面倒？を直観で理解する](https://zenn.dev/kafka2306/articles/3536e2f7c67656)（記事）。UI、データの流れ、インフラごとに責任範囲を明確にする。

[データ設計](skills/data/SKILL.md) · [自律開発](skills/build/SKILL.md)

### 応用情報の略語と用途

[応用情報の略語問題](https://zenn.dev/kafka2306/articles/a991574ccef77e)（記事）。略語を正式名称と用途に対応づけて用語を確認する。

[データ設計](skills/data/SKILL.md) · [文書校正](skills/edit/SKILL.md)

### wsl2でのunity-hub導入

[WSL2でUnity Hubをインストールする方法](https://zenn.dev/kafka2306/articles/5ef689985e9aee)（記事）。WSL2でUnity Hubとエディターを用意する際の手順を参照する。

[自律開発](skills/build/SKILL.md)

## ISUCONのハーネス

### isuconの準備

[ISUCON2026 で優勝しました（準備編）](https://zenn.dev/luvtechno/articles/isucon2026-preparation)（当事者の実践記録）。素の構成を先に測り、追加した知識や道具の効果を同じ課題で比較する。

[自動評価](skills/test/SKILL.md) · [自律開発](skills/build/SKILL.md)

### isuconの優勝ハーネス

[fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](https://fukabori.fm/episode/142)（当事者インタビュー）。長時間の自律実行、競技用ハーネスを小さくした経緯、計測と停止の判断を参照する。

[自律開発](skills/build/SKILL.md) · [自動評価](skills/test/SKILL.md)
