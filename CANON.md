---
type: reference
tags:
  - kafstyler/canon
---

# 聖典台帳

各行の一次URLから原典を読み、右端のコマンドから適用手順を確認できる。[台帳の更新手順](MISSION.md#更新手順)・[評価指標](MISSION.md#mission-evaluation)・[外部手法への置き換え](MISSION.md#mission-adopt-upstream)

<a name="obsidian-note-metadata"></a>

## ノートのfrontmatterとタグ

Obsidianに置くMarkdownノートでは、ファイル先頭のYAMLにプロパティを書く。用途を表す `type` は文字列、検索に使う `tags` はリストとし、保管庫内で既存のキーと型をそろえる。実際に別名で探す場合は `aliases` をリストで加える。

タグは小文字を使い、複数語はハイフンでつなぐ。親タグでも検索する場合に階層を `/` で区切る。この台帳ではYAMLに `kafstyler/canon` と書き、Obsidianでは `tag:#kafstyler/canon` で検索する。Claude Codeのコマンドには公式仕様で認められたプロパティを使う。

[Obsidianのプロパティ仕様](#canon-obsidian-properties)・[タグ仕様](#canon-obsidian-tags)・[データ設計](commands/data-design.md)

## 目標・文章・評価

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-nobori-design"></a>[登大遊・論理的思考の放棄](https://softether.hatenadiary.org/entry/20070324/p1) | 原典 | 完成時の利用場面と最初の違和感 | [目標設定](commands/outcome-design.md) |
| <a name="canon-claude-code-practices"></a>[Anthropic・Claude Codeの実践ガイド](https://code.claude.com/docs/en/best-practices) | 公式ガイド | 依頼の範囲、検証、作業の進め方 | [目標設定](commands/outcome-design.md) · [自律開発](commands/autonomous-development.md) |
| <a name="canon-anthropic-evaluation"></a>[Anthropic・成功基準と評価の設計](https://platform.claude.com/docs/en/test-and-evaluate/develop-tests) | 公式ガイド | 成功条件、テストケース、採点方法 | [自動評価](commands/automated-evaluation.md) · [対立仮説](commands/devils-advocate.md) |
| <a name="canon-humanizer-ja"></a>[imoz・日本語の文章編集ガイド](https://imoz.jp/humanizer.ja.txt) | 編集ガイド | 任意の出力に含まれる人向け文章の執筆と校正 | [自動評価](commands/automated-evaluation.md) · [自律開発](commands/autonomous-development.md) · [データ設計](commands/data-design.md) · [致命的な欠陥のレビュー](commands/devils-advocate.md) · [文書校正](commands/editorial.md) · [目標設定](commands/outcome-design.md) · [AIスロップ削除](commands/remove-ai-slop.md) |

## エージェントとハーネス

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-anthropic-skill-authoring"></a>[Anthropic・Agent Skills執筆ガイド](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) | 公式ガイド | スキルの記述、検証、手直し | [自律開発](commands/autonomous-development.md) · [AIスロップ削除](commands/remove-ai-slop.md) |
| <a name="canon-claude-code-skills"></a>[Anthropic・Claude Code Skills](https://code.claude.com/docs/en/skills) | 公式仕様 | スキルの配置と呼び出し | [自律開発](commands/autonomous-development.md) |
| <a name="canon-claude-plugin-creation"></a>[Anthropic・Claude Codeプラグインの作成](https://code.claude.com/docs/en/plugins/create) | 公式ガイド | プラグインの作成と検証 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-claude-plugin-components"></a>[Anthropic・プラグインの構成要素](https://code.claude.com/docs/en/plugins/components) | 公式仕様 | コマンドやスキルの構成 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-claude-plugin-manifest"></a>[Anthropic・プラグインマニフェスト仕様](https://code.claude.com/docs/en/plugins/manifest-reference) | 公式仕様 | マニフェストの項目と形式 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-deepseek-harness-docs"></a>[DeepSeek Harness・公式開発者ドキュメント](https://deepseek-harness.github.io/deepseek-harness/) | 公式開発者ドキュメント | DeepSeek Harnessの利用と拡張 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-deepseek-harness-architecture"></a>[DeepSeek Harness・アーキテクチャ](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/architecture.md) | 公式設計文書 | Cordis、プロファイル、バンドルの構成 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-agent-skills-standard"></a>[Agent Skills・仕様](https://agentskills.io/specification) | 標準仕様 | SKILL.mdの形式、名前と説明、補助資料の配置 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-mcp-tools"></a>[Model Context Protocol・Tools](https://modelcontextprotocol.io/specification/latest/server/tools) | 標準仕様 | MCPツールの発見、入力スキーマ、呼び出しと結果 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-openai-harness-engineering"></a>[OpenAI・Harness engineering](https://openai.com/index/harness-engineering/) | 公式技術記事 | エージェントがたどれるリポジトリ構成と検証 | [自律開発](commands/autonomous-development.md) · [自動評価](commands/automated-evaluation.md) |
| <a name="canon-anthropic-long-running-harness"></a>[Anthropic・Effective harnesses for long-running agents](https://www.anthropic.com/research/effective-harnesses-for-long-running-agents) | 公式技術記事 | 長時間作業の引き継ぎと成果の確認 | [自律開発](commands/autonomous-development.md) · [自動評価](commands/automated-evaluation.md) |

## AIエンジニアリングの書籍

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-chip-huyen-ai-engineering"></a>[Chip Huyen・AI Engineering](https://www.oreilly.com/library/view/ai-engineering/9781098166298/) | 書籍 | 基盤モデルを使うアプリケーションの設計と評価 | [自律開発](commands/autonomous-development.md) · [自動評価](commands/automated-evaluation.md) |
| <a name="canon-manning-agent-engineering"></a>[Manning・Agent Engineering](https://www.manning.com/books/agent-engineering) | 書籍 | 自律性の設計、ツール連携、評価とフィードバック | [自律開発](commands/autonomous-development.md) · [自動評価](commands/automated-evaluation.md) |

## データ・オントロジー・命名

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-iof-ontology"></a>[Industrial Ontologies Foundry・IOF Ontology Portal](https://spec.industrialontologies.org/portal/) | 公式ポータル | 産業分野の共通概念と関係 | [データ設計](commands/data-design.md) |
| <a name="canon-foundry-ontology"></a>[Palantir Foundry・Ontology](https://www.palantir.com/docs/foundry/ontology/overview/) | 公式ドキュメント | 業務で扱うオブジェクト、関係、操作 | [データ設計](commands/data-design.md) |
| <a name="canon-foundry-data-lineage"></a>[Palantir Foundry・Data Lineage](https://www.palantir.com/docs/foundry/data-lineage/overview/) | 公式ドキュメント | データの出所と派生先の追跡 | [データ設計](commands/data-design.md) |
| <a name="canon-microsoft-star-schema"></a>[Microsoft Learn・スター・スキーマ](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema) | 公式ガイド | ファクトとディメンションの設計 | [データ設計](commands/data-design.md) |
| <a name="canon-kimball-grain"></a>[Kimball Group・ファクトの粒度](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/) | 設計原典 | ファクトの1行が何を表すかの定義 | [データ設計](commands/data-design.md) |
| <a name="canon-w3c-prov-o"></a>[W3C・PROV-O 来歴の標準](https://www.w3.org/TR/prov-o/) | 標準仕様 | 根拠となる実体、活動、主体の関係 | [データ設計](commands/data-design.md) |
| <a name="canon-w3c-dcat"></a>[W3C・DCAT 3 データカタログの標準](https://www.w3.org/TR/vocab-dcat-3/) | 標準仕様 | データセットと配布物の記述 | [データ設計](commands/data-design.md) |
| <a name="canon-dbt-introduction"></a>[dbt Developer Hub・dbtの概要](https://docs.getdbt.com/docs/introduction) | 公式ドキュメント | 変換モデルの構成 | [データ設計](commands/data-design.md) |
| <a name="canon-dbt-sources"></a>[dbt・ソースと来歴](https://docs.getdbt.com/docs/build/sources) | 公式ドキュメント | 入力データの定義と来歴 | [データ設計](commands/data-design.md) |
| <a name="canon-dbt-data-tests"></a>[dbt・データ品質テスト](https://docs.getdbt.com/docs/build/data-tests) | 公式ドキュメント | データ品質条件の検証 | [データ設計](commands/data-design.md) · [自動評価](commands/automated-evaluation.md) |
| <a name="canon-general-naming"></a>[Microsoft・General Naming Conventions](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/general-naming-conventions) | 公式ガイド | .NETの指針から、意味が伝わる語を選び、よく知られた略語だけを使う原則を採用する。 | [データ設計](commands/data-design.md) · [自律開発](commands/autonomous-development.md) |

## Obsidian

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-obsidian-properties"></a>[Obsidian・Properties](https://obsidian.md/help/properties) | 公式ドキュメント | ファイル先頭のYAML、プロパティの名前と型 | [データ設計](commands/data-design.md) |
| <a name="canon-obsidian-tags"></a>[Obsidian・Tags](https://obsidian.md/help/tags) | 公式ドキュメント | タグのリスト、階層、検索 | [データ設計](commands/data-design.md) |

## CLI・開発・インフラ

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-unix-philosophy"></a>[McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](https://doi.org/10.1002/j.1538-7305.1978.tb02135.x) | 原典 | 一つのプログラムに一つの仕事を任せ、入出力でつなぐ | [自律開発](commands/autonomous-development.md) · [AIスロップ削除](commands/remove-ai-slop.md) |
| <a name="canon-pydantic"></a>[Pydantic・検証の公式ドキュメント](https://pydantic.dev/docs/validation/latest/get-started/) | 公式ドキュメント | データの型と入力値の検証 | [データ設計](commands/data-design.md) · [自律開発](commands/autonomous-development.md) |
| <a name="canon-astral-uv"></a>[Astral・uv](https://docs.astral.sh/uv/) | 公式ドキュメント | Pythonの環境と依存関係 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-astral-ruff"></a>[Astral・Ruff](https://docs.astral.sh/ruff/) | 公式ドキュメント | Pythonのlintと整形 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-astral-ty"></a>[Astral・ty](https://docs.astral.sh/ty/) | 公式ドキュメント | Pythonの型検査 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-pulumi-iac"></a>[Pulumi・Infrastructure as Code](https://www.pulumi.com/docs/iac/) | 公式ドキュメント | インフラ構成の実装 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-pulumi-preview"></a>[Pulumi・変更の事前確認（pulumi preview）](https://www.pulumi.com/docs/iac/cli/commands/pulumi_preview/) | 公式手順 | インフラ変更の適用前確認 | [自律開発](commands/autonomous-development.md) |

## UIとComfyUI

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-google-demolab"></a>[Google Gemini・DemoLabのフロントエンド設計スキル](https://github.com/google-gemini/demolab#installation) | 公式スキル | フロントエンド設計 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-comfyui-docs"></a>[ComfyUI・公式ドキュメント](https://docs.comfy.org/) | 公式ドキュメント | ComfyUIの基本操作 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-comfyui-workflow-templates"></a>[ComfyUI・Workflow Templatesの使い方](https://docs.comfy.org/interface/features/template) | 公式手順 | テンプレートの選び方と実行 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-comfyui-template-source"></a>[ComfyUI・公式テンプレートの正本](https://github.com/Comfy-Org/workflow_templates) | 公式実装 | テンプレートの取得元 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-comfyui-workflow-json"></a>[ComfyUI・Workflow JSON仕様原本](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx) | 公式仕様 | ワークフローのJSON形式 | [自律開発](commands/autonomous-development.md) |

<a name="unity-vrchat-tools"></a>

## UnityとVRChatの制作ツール

用途ごとに1本を選定。Starsは2026-11-17にGitHubで取得した値。

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-unity-coplay"></a>[汎用Unity・CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp) | 開発元実装 | シーン、アセット、テスト、ビルドを扱う50のMCPツール。MIT。GitHub Stars 16,030。 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-vrc-worlds"></a>[VRChat Worlds・swax/UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC) | 開発元実装 | UdonSharpの補助とエディター画面の確認。GitHub Stars 73。CC BY-NC 4.0のため、BOOTH向けなどの商用制作では利用条件を事前に確認する。[ライセンス原文](https://github.com/swax/UnityMCP-VRC/blob/main/LICENSE) | [自律開発](commands/autonomous-development.md) |
| <a name="canon-vrc-avatars"></a>[VRChat Avatars・lighfu/unity-agent](https://github.com/lighfu/unity-agent) | 開発元実装 | READMEに400以上の操作ツールとComfyUI連携を記載。Avatar Descriptorの検査、PhysBoneの設定、Modular Avatarによる衣装導入、SDKビルドとアップロードを扱う。MIT。GitHub Stars 45。[衣装導入手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md)・[SDKビルド手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md) | [自律開発](commands/autonomous-development.md) |

## Tripoと3D生成

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-tripo-studio"></a>[Tripo Studio・公式ドキュメント](https://www.tripo3d.ai/product-doc) | 公式ドキュメント | Studioでの制作 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-tripo-api"></a>[Tripo API・公式ドキュメント](https://developers.tripo3d.ai/en/docs/introduction) | 公式ドキュメント | APIを使った生成処理 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-tripo-comfyui"></a>[Tripo・ComfyUIノードの公式ドキュメント](https://developers.tripo3d.ai/en/docs/comfyui-nodes) | 公式ドキュメント | ComfyUIでのノード設定 | [自律開発](commands/autonomous-development.md) |
| <a name="canon-tripo-publications"></a>[Tripo / VAST AI・論文一覧](https://www.tripo3d.ai/research/publications) | 論文一覧 | 関連する手法の検索 | [自律開発](commands/autonomous-development.md) · [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-sr"></a>[TripoSR・単一画像からの3D復元](https://arxiv.org/abs/2403.02151) | 技術報告 | 単一画像からの3D復元 | [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-sg"></a>[TripoSG・高精細な3D形状生成](https://arxiv.org/abs/2502.06608) | 論文 | 3D形状の生成と品質評価 | [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-sparseflex"></a>[SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](https://arxiv.org/abs/2503.21732) | 論文 | 任意のトポロジーを持つ形状の表現 | [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-splat"></a>[TripoSplat・密度を制御する3Dガウシアン生成](https://arxiv.org/abs/2605.16355) | 論文 | 密度を制御する3Dガウシアン生成 | [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-anigen"></a>[AniGen・アニメーション可能な3Dアセット生成](https://arxiv.org/abs/2604.08746) | 論文 | アニメーション可能な3Dアセット生成 | [自動評価](commands/automated-evaluation.md) |
| <a name="canon-tripo-nexus"></a>[Nexus・頂点とトポロジーを扱うメッシュ生成](https://doi.org/10.1145/3811344) | 論文 | 頂点とトポロジーを扱うメッシュ生成 | [自動評価](commands/automated-evaluation.md) |

## かふかのZenn

| 資料 | 種別 | 用途・留意点 | 対応コマンド |
| --- | --- | --- | --- |
| <a name="canon-kafka-zenn"></a>[かふかのZenn記事一覧](https://zenn.dev/kafka2306?tab=articles) | 記事一覧 | 掲載される公開記事をすべて含む。作業に関係する記事を一覧から参照する。 | [自動評価](commands/automated-evaluation.md) · [自律開発](commands/autonomous-development.md) · [データ設計](commands/data-design.md) · [対立仮説](commands/devils-advocate.md) · [文書校正](commands/editorial.md) · [目標設定](commands/outcome-design.md) · [AIスロップ削除](commands/remove-ai-slop.md) |
