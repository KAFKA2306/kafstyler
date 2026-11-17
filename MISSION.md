# MISSION

普段の依頼を、他の案件でもそのまま使える短い作業手順にする。各スキルは、何を受け取り、どんな結果を返し、どう確かめるかを1ファイルに収める。

## 更新手順

1. 探す。会話、Issue、成果物から、繰り返した指示と、その指示で変わった操作や判断を拾う。会話は本人の依頼を対象にし、同じ意味の表記揺れをまとめ、同じ会話では1件と数える。Issueの件数は会話と分ける。検索期間、閲覧できた範囲、分母、未確認範囲を記録する。
2. 採否を決める。異なる会話2件以上か本人の明示指定を起点にし、別の案件でも同じ手順を呼び出せるものを選ぶ。入力と成果物が同じ既存コマンドがあれば統合する。隣のコマンドと独立して呼ぶ場面があれば、出力の違いをREADMEで確認する。担当プロジェクト固有の手順はそのプロジェクトに置く。
3. 書く。通常の利用場面と利用者が確認できる結果を先に決める。公式資料で用語と操作を確認し、`commands/<name>.md` の description に呼び出し条件、本文に手順と完了判定を書く。各ファイルは独立した依頼1件に対応させる。公式資料はこのページに収め、参照先を追加・変更するときは対応するコマンドへのリンクと、コマンド側の参照リンクを同じ変更で更新する。
4. 試す。直近と別分野の依頼を1件ずつ使い、入力から出力と確認までを見直す。似たスキルを呼び分けられるかも確認する。内部リンク、公式URL、ファイル一覧、保存した版を読み戻す。Claude Codeがある環境では `claude plugin validate .` と `claude --plugin-dir .` を実行し、変更した `/kafstyler:<name>` を確認する。PRには対象・確認した結果・残る不明点を記録する。
5. 整理する。後継へ移した内容と参照元を確認し、不要なファイル・リンクを同じPRで削除する。旧版はGit履歴から辿れるようにする。マージ後に main の入口、一覧、ファイル数とフォルダ数を確認する。

## 外部実装への置き換え

同じ用途で外部の実装が自作より良ければ、積極的に置き換える。上流の保守と品質保証を利用し、使い方や設計の選択肢を広げる。

1. 自作の機能を使う具体的な場面を選び、公式ドキュメントと外部開発者の実例から候補を探す。
2. 同じ入力で使い、必要な出力、動作環境、上流の検証実績と保守状況を比べる。運用や移行の手間も確認する。
3. 良い候補へ切り替え、通常の入口で出力を確かめる。役割を終えた自作コードや設定を削る。

## 自動化の量

workflow、CI、tests、scripts、hooksは必要最小限の半分を目安にする。過剰なチェックで日常作業を止めた経験を踏まえ、まず既存の実行入口と検証を使う。追加する場合は、防ぐ具体的な失敗か、減らせる手作業を示す。

## 初回棚卸し

見えていた過去会話40件では、ゴール設定10件、実行へ進む指示9件、ブリーフ7件、humanize・AIスロップ削除6件、視点変更・対立仮説4件、既存の外部機能やスクリプトで簡素化する指示4件を確認した。同じ会話は各項目で最大1件。項目間には重複があり、全履歴の頻度は未確認。

追加の検索では、スター・スキーマの本人指示が少なくとも6会話、台帳とメタデータの同時指定が1会話、英語表記の反対仮説レビュー指定が1会話。別にGitHubの作業記録で、台帳3件、スター・スキーマ3件、メタデータ5件を確認した。会話の原文と検索抜粋はここに保存しない。

## 聖典

### ゴールとスキル

- <a name="canon-anthropic-skill-authoring"></a>[Anthropic・Agent Skills執筆ガイド](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) （[自律開発](commands/autonomous-development.md)、[AIスロップ削除](commands/remove-ai-slop.md)）
- <a name="canon-claude-code-skills"></a>[Anthropic・Claude Code Skills](https://code.claude.com/docs/en/skills) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-claude-plugin-creation"></a>[Anthropic・Claude Codeプラグインの作成](https://code.claude.com/docs/en/plugins/create) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-claude-plugin-components"></a>[Anthropic・プラグインの構成要素](https://code.claude.com/docs/en/plugins/components) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-claude-plugin-manifest"></a>[Anthropic・プラグインマニフェスト仕様](https://code.claude.com/docs/en/plugins/manifest-reference) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-claude-code-practices"></a>[Anthropic・Claude Codeの実践ガイド](https://code.claude.com/docs/en/best-practices) （[目標設定](commands/outcome-design.md)、[自律開発](commands/autonomous-development.md)）
- <a name="canon-anthropic-evaluation"></a>[Anthropic・成功基準と評価の設計](https://platform.claude.com/docs/en/test-and-evaluate/develop-tests) （[自動評価](commands/automated-evaluation.md)、[対立仮説](commands/devils-advocate.md)）
- <a name="canon-nobori-design"></a>[登大遊・論理的思考の放棄](https://softether.hatenadiary.org/entry/20070324/p1) （[目標設定](commands/outcome-design.md)）
- <a name="canon-humanizer-ja"></a>[imoz・日本語の文章編集ガイド](https://imoz.jp/humanizer.ja.txt) （[文書校正](commands/editorial.md)、[AIスロップ削除](commands/remove-ai-slop.md)）

### 台帳・オントロジー・データ設計

- <a name="canon-iof-ontology"></a>[Industrial Ontologies Foundry・IOF Ontology Portal](https://spec.industrialontologies.org/portal/) （[データ設計](commands/data-design.md)）
- <a name="canon-foundry-ontology"></a>[Palantir Foundry・Ontology](https://www.palantir.com/docs/foundry/ontology/overview/) （[データ設計](commands/data-design.md)）
- <a name="canon-foundry-data-lineage"></a>[Palantir Foundry・Data Lineage](https://www.palantir.com/docs/foundry/data-lineage/overview/) （[データ設計](commands/data-design.md)）
- <a name="canon-microsoft-star-schema"></a>[Microsoft Learn・スター・スキーマ](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema) （[データ設計](commands/data-design.md)）
- <a name="canon-kimball-grain"></a>[Kimball Group・ファクトの粒度](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/grain/) （[データ設計](commands/data-design.md)）
- <a name="canon-w3c-prov-o"></a>[W3C・PROV-O 来歴の標準](https://www.w3.org/TR/prov-o/) （[データ設計](commands/data-design.md)）
- <a name="canon-w3c-dcat"></a>[W3C・DCAT 3 データカタログの標準](https://www.w3.org/TR/vocab-dcat-3/) （[データ設計](commands/data-design.md)）
- <a name="canon-dbt-introduction"></a>[dbt Developer Hub・dbtの概要](https://docs.getdbt.com/docs/introduction) （[データ設計](commands/data-design.md)）
- <a name="canon-dbt-sources"></a>[dbt・ソースと来歴](https://docs.getdbt.com/docs/build/sources) （[データ設計](commands/data-design.md)）
- <a name="canon-dbt-data-tests"></a>[dbt・データ品質テスト](https://docs.getdbt.com/docs/build/data-tests) （[データ設計](commands/data-design.md)、[自動評価](commands/automated-evaluation.md)）

### 実装と制作

- <a name="canon-pydantic"></a>[Pydantic・検証の公式ドキュメント](https://pydantic.dev/docs/validation/latest/get-started/) （[データ設計](commands/data-design.md)、[自律開発](commands/autonomous-development.md)）
- <a name="canon-astral-uv"></a>[Astral・uv](https://docs.astral.sh/uv/) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-astral-ruff"></a>[Astral・Ruff](https://docs.astral.sh/ruff/) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-astral-ty"></a>[Astral・ty](https://docs.astral.sh/ty/) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-google-demolab"></a>[Google Gemini・DemoLabのフロントエンド設計スキル](https://github.com/google-gemini/demolab#installation) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-comfyui-docs"></a>[ComfyUI・公式ドキュメント](https://docs.comfy.org/) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-comfyui-workflow-templates"></a>[ComfyUI・Workflow Templatesの使い方](https://docs.comfy.org/interface/features/template) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-comfyui-template-source"></a>[ComfyUI・公式テンプレートの正本](https://github.com/Comfy-Org/workflow_templates) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-comfyui-workflow-json"></a>[ComfyUI・Workflow JSON仕様原本](https://github.com/Comfy-Org/docs/blob/main/specs/workflow_json.mdx) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-pulumi-iac"></a>[Pulumi・Infrastructure as Code](https://www.pulumi.com/docs/iac/) （[自律開発](commands/autonomous-development.md)）
- <a name="canon-pulumi-preview"></a>[Pulumi・変更の事前確認（pulumi preview）](https://www.pulumi.com/docs/iac/cli/commands/pulumi_preview/) （[自律開発](commands/autonomous-development.md)）

### かふかのZenn

<a name="canon-kafka-zenn"></a>[かふかのZenn記事一覧](https://zenn.dev/kafka2306?tab=articles) に掲載される公開記事はすべて聖典に含める。更新時は、その作業に関係する記事を一覧から読んで使う。 （[自動評価](commands/automated-evaluation.md)、[自律開発](commands/autonomous-development.md)、[データ設計](commands/data-design.md)、[対立仮説](commands/devils-advocate.md)、[文書校正](commands/editorial.md)、[目標設定](commands/outcome-design.md)、[AIスロップ削除](commands/remove-ai-slop.md)）
