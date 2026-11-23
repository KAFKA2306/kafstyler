---
type: reference
description: "設計とUIの一次資料と判断基準"
tags:
  - kafstyler/canon
  - kafstyler/reference
---

# 設計とUI

## かふかのデザインパターン

[KAFKA2306/design](https://github.com/KAFKA2306/design) は、KAFKA2306のプロジェクトが共有するWeb UIの設計正本。共通部品、見た目、操作状態の定義は上流を読み、業務ルール、データ、公開環境は各プロジェクトの正本を使う。共有デザインを導入するときは、利用側の `design.config.json` で採用する版をコミットSHAに固定する。

### 利用者の操作の順番

確認して行動する、比較して決める、調査してから行動する、実行して結果を確認する、の中から実際の操作に合う順番を選ぶ。[操作パターンの実装](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/journey.ts)

使うスキルは[目標設定](../skills/reconceptualize/SKILL.md)と[自律開発](../skills/autocatalyze/SKILL.md)。

### 判断に必要な情報と文言

利用者が結論、理由、根拠、次の操作を見つけられるようにする。実績、予測、仮説、未確認を表示まで区別する。[共通の判断パネル](https://github.com/KAFKA2306/design/blob/main/registry/ui/product/decision.tsx) · [コンテンツのスキーマ](https://github.com/KAFKA2306/design/blob/main/artifacts/content.schema.json)

使うスキルは[データ設計](../skills/canonicalize/SKILL.md)と[知見の教材化と推敲](../skills/didactization/SKILL.md)。

### 部品と見た目の正本

共通の部品とトークンを使い、同期後の状態を検証する。利用側で同じ値や部品を独立して維持する箇所は、置き換え後に整理する。[設計・同期の手順](https://github.com/KAFKA2306/design/blob/main/skills/frontend-design/SKILL.md#workflow) · [共通トークン](https://github.com/KAFKA2306/design/blob/main/tokens/foundation.tokens.json)

使うスキルは[自律開発](../skills/autocatalyze/SKILL.md)と[不要なファイル・コード・文章の削除](../skills/decommission/SKILL.md)。

### 画面の評価

[画面評価ガイド](https://github.com/KAFKA2306/design/blob/main/docs/frontend-review.md)（共有デザインの手順）で見た目と操作を確かめる。状態と入力方法の要件は[設計と検証の基準](https://github.com/KAFKA2306/design#current-design-contract)を使う。

使うスキルは[画面の評価](../skills/adjudicate/SKILL.md#画面の評価)、[反証レビュー](../skills/disprove/SKILL.md)、[目標設定](../skills/reconceptualize/SKILL.md)。


## UIとComfyUI

### Googleの画面設計

[Google Gemini・DemoLabのフロントエンド設計スキル](https://github.com/google-gemini/demolab#installation)（公式スキル）。フロントエンド設計

[自律開発](../skills/autocatalyze/SKILL.md)

### ComfyUIの公式文書

[ComfyUI・公式ドキュメント](https://docs.comfy.org/)（公式ドキュメント）。ComfyUIの基本操作

[自律開発](../skills/autocatalyze/SKILL.md)

### ComfyUIのワークフロー選定

[ComfyUI Workflow選定と採用の基準](https://github.com/KAFKA2306/comfyui-workflows-factory/blob/main/docs/knowledge/best-workflows.md)（制作の選定基準）。8領域の第一候補、代替、原典、採用前に確かめる条件

[自律開発](../skills/autocatalyze/SKILL.md)

### ComfyUIのテンプレート

[ComfyUI・Workflow Templatesの使い方](https://docs.comfy.org/interface/features/template)（公式手順）。テンプレートの選び方と実行

[自律開発](../skills/autocatalyze/SKILL.md)

### ComfyUIのテンプレート正本

[ComfyUI・公式テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)（公式実装）。テンプレートの取得元

[自律開発](../skills/autocatalyze/SKILL.md)

### ComfyUIのワークフロー形式

[ComfyUI・Workflow JSON仕様原本](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx)（公式仕様）。ワークフローのJSON形式

[自律開発](../skills/autocatalyze/SKILL.md)
