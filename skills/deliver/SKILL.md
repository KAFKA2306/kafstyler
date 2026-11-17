---
name: deliver
type: "skill"
description: "許可された変更を実装し、実際の利用経路で確かめて届ける。自律開発、実装、作業手順の簡素化に使う。"
tags:
  - kafstyler/skill
  - kafstyler/skill/deliver
aliases:
  - "自律開発"
  - "開発"
---

# 自律開発

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../../BIBLES.md#imozの日本語編集)を適用する。[出力の共通基準](../../MISSION.md#出力の共通基準)

1. プロジェクトの現状、利用者が使う入口、合格条件を確認する。目標が曖昧なら、Claude Codeの `Skill` ツールで [`kafstyler:charter`](../charter/SKILL.md) を呼ぶ。`args` に依頼、現在の入口、観測できた問題を渡し、完成場面と合格条件を実装に使う。進行中のIssueやPRがあればその作業を引き継ぐ。データ構造の設計が必要なら、`Skill` で [`kafstyler:schema`](../schema/SKILL.md) を呼ぶ。答える問い、実データの例、変更範囲を `args` に渡し、結果を実装に使う。作業を分けるときは、各単位の担当、成果物、合格条件を決める。人間による認証が必要な場合は、事前確認を済ませ、必要な操作と再開条件を伝える。
2. 実際の障害を確認し、役割を終えた経路や重複を除く。標準の道具と公式APIを使い、依頼に必要な変更単位を選ぶ。フロントエンドでは、プロジェクトのデザイン規則に従う。[目標設定](../charter/SKILL.md)で決めた操作を、利用者が使う画面幅で入口から完了まで確かめる。利用できる場合は `demolab:gemini-frontend-design` を使う。[DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)
3. 現行方式の前提や置き換え候補の反証が依頼に含まれる場合は、`Skill` で [`kafstyler:scrutiny`](../scrutiny/SKILL.md) を呼ぶ。`args` に検証する前提、観測された問題、置き換えの条件を渡す。手法を置き換える場合は、`Skill` で [`kafstyler:benchmark`](../benchmark/SKILL.md) を呼び、現行と候補、共通の入力、合格条件を `args` に渡す。評価で合格し、品質や運用工数が改善し、保守と検証の根拠がある候補を採用する。通常の入口で移行後の動作を確認したら、`Skill` で [`kafstyler:prune`](../prune/SKILL.md) を呼び、置き換えた旧実装、整理の範囲、移行時の評価結果を `args` に渡す。
4. ComfyUIでは `Workflow → Browse Workflow Templates` から[公式テンプレート](https://github.com/Comfy-Org/workflow_templates)を選び、元の版と必要モデルを記録する。実際の環境で出力を確かめる。[Unity・VRChat制作](../../BIBLES.md#ユニティとvrchatの制作ツール)では用途に合うツールを選び、対象プロジェクトで確かめる。シェルでは一つのコマンドに一つの仕事を任せ、標準入出力でつなぐ。
5. 既存の確認を使い、対象の失敗を検出できる最小の検証と、利用者の操作経路での確認を実行する。新しいワークフロー、CI、テスト、スクリプト、フックは具体的な失敗を検出するか、実測した繰り返し作業を減らす場合に加える。整理では重複した確認を取り除き、削減した件数や工数を測る。
6. 対象リポジトリの規約に従って配布する。Kafstylerでは[作業規約](../../AGENTS.md#ブランチとコミット)に従い、同じチェックアウトで作業し、確認した変更単位ごとに `main` にコミットする。PRを使うリポジトリでは差分、マージ、反映、後片付けまで確認する。公開する変更では、対象コミットから生成した成果物を、公開先が実際に返したファイルや版と照合する。その公開先で利用者の操作を最後まで通す。成果物が古ければビルド設定と配信先を調べる。

動作する変更と根拠を届ける。実行を妨げる問題が残る場合は次の作業を示す。

## 関連ミッション

[自律改善](../../MISSION.md#自律改善)・[自律成果創出](../../MISSION.md#自律成果創出)・[外部手法への置き換え](../../MISSION.md#外部実装への置き換え)

## 参照資料

- [Anthropic・Agent Skills執筆ガイド](../../BIBLES.md#スキルの執筆)
- [Anthropic・Claude Code Skills](../../BIBLES.md#claude-codeのスキル)
- [Anthropic・Claude Codeプラグインの作成](../../BIBLES.md#プラグインの作成)
- [Anthropic・プラグインの構成要素](../../BIBLES.md#プラグインの構成)
- [Anthropic・プラグインマニフェスト仕様](../../BIBLES.md#プラグインのマニフェスト)
- [Anthropic・Claude Codeの実践ガイド](../../BIBLES.md#claude-codeの実践)
- [Pydantic・検証の公式ドキュメント](../../BIBLES.md#pydanticのデータ検証)
- [Astral・uv](../../BIBLES.md#uvの環境管理)
- [Astral・Ruff](../../BIBLES.md#ruffの静的解析)
- [Astral・ty](../../BIBLES.md#tyの型検査)
- [Google Gemini・DemoLabのフロントエンド設計スキル](../../BIBLES.md#googleの画面設計)
- [ComfyUI・公式ドキュメント](../../BIBLES.md#comfyuiの公式文書)
- [ComfyUI・Workflow Templatesの使い方](../../BIBLES.md#comfyuiのテンプレート)
- [ComfyUI・公式テンプレートの正本](../../BIBLES.md#comfyuiのテンプレート正本)
- [ComfyUI・Workflow JSON仕様原本](../../BIBLES.md#comfyuiのワークフロー形式)
- [Pulumi・Infrastructure as Code](../../BIBLES.md#pulumiの構成管理)
- [Pulumi・変更の事前確認（pulumi preview）](../../BIBLES.md#pulumiの差分確認)
- [Tripo Studio・公式ドキュメント](../../BIBLES.md#tripo-studio)
- [Tripo API・公式ドキュメント](../../BIBLES.md#tripoのapi)
- [Tripo・ComfyUIノードの公式ドキュメント](../../BIBLES.md#tripoのcomfyui連携)
- [Tripo / VAST AI・論文一覧](../../BIBLES.md#tripoの研究一覧)
- [Microsoft・General Naming Conventions](../../BIBLES.md#命名規則)
- [DeepSeek Harness・公式開発者ドキュメント](../../BIBLES.md#deepseek-harnessの使い方)
- [DeepSeek Harness・アーキテクチャ](../../BIBLES.md#deepseek-harnessの構成)
- [McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](../../BIBLES.md#unix哲学)
- [汎用Unity・CoplayDev/unity-mcp](../../BIBLES.md#ユニティの汎用mcp)
- [VRChat Worlds・swax/UnityMCP-VRC](../../BIBLES.md#vrchatのワールド制作)
- [VRChat Avatars・lighfu/unity-agent](../../BIBLES.md#vrchatのアバター制作)
- [Agent Skills・仕様](../../BIBLES.md#エージェントスキルの仕様)
- [Model Context Protocol・Tools](../../BIBLES.md#mcpのツール仕様)
- [OpenAI・Harness engineering](../../BIBLES.md#openaiのハーネス設計)
- [Anthropic・Effective harnesses for long-running agents](../../BIBLES.md#長時間稼働するエージェント)
- [Chip Huyen・AI Engineering](../../BIBLES.md#aiエンジニアリングの書籍)
- [Manning・Agent Engineering](../../BIBLES.md#エージェント設計の書籍)
- [かふかのZenn記事一覧](../../BIBLES.md#かふかのzenn記事一覧)
- [imoz・日本語の文章編集ガイド](../../BIBLES.md#imozの日本語編集)
- [ISUCON2026 で優勝しました（準備編）](../../BIBLES.md#isuconの準備)
- [fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](../../BIBLES.md#isuconの優勝ハーネス)
- [OpenAI・現場で成果を届けるエンジニアリング（What FDE means at OpenAI）](../../BIBLES.md#openaiの現場開発)
- [issue駆動開発](../../BIBLES.md#issue駆動開発)
- [個人開発の次の一件](../../BIBLES.md#個人開発の次の一件)
- [自動テストの合格条件](../../BIBLES.md#自動テストの合格条件)
- [windowsでのgemini-cli導入](../../BIBLES.md#windowsでのgemini-cli導入)
- [エージェント向け運用基盤](../../BIBLES.md#エージェント向け運用基盤)
- [astralのpython開発基盤](../../BIBLES.md#astralのpython開発基盤)
- [steamvrの起動障害](../../BIBLES.md#steamvrの起動障害)
- [wsl2でのantigravity導入](../../BIBLES.md#wsl2でのantigravity導入)
- [taskで共通の実行手順を作る](../../BIBLES.md#taskで共通の実行手順を作る)
- [windowsとwslの自動化](../../BIBLES.md#windowsとwslの自動化)
- [アプリの責任範囲を分ける](../../BIBLES.md#アプリの責任範囲を分ける)
- [wsl2でのunity-hub導入](../../BIBLES.md#wsl2でのunity-hub導入)
