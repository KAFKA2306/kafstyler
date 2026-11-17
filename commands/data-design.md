---
description: "エンティティ、オントロジー、メタデータ、台帳、マスター、スタースキーマ、dbtのデータ構造を設計する。"
---

# データ設計

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../CANON.md#canon-humanizer-ja)を適用する。[出力の共通基準](../MISSION.md#mission-output-style)

1. 答える問い、現行データの管理者、実際の入力を確かめる。エンティティの識別子、関係、操作を定義する。産業分野の概念にはIOF、業務オブジェクトにはFoundryの設計を必要に応じて参照する。
2. 検索、判断、検証に使う項目を選ぶ。必要に応じて出典ID、URL、時点、版、単位、欠損値の意味、来歴を持たせる。名前はプロジェクトで使われている語彙から選ぶ。
3. 台帳は一行のキー、状態遷移、訂正履歴を定め、再入力時の照合方法を決める。マスターは識別子、正とする属性、必要に応じて有効期間を定める。
4. 分析では最初にファクトの一行が表す粒度を定める。粒度ごとに集計し、結合後の件数増加、対応先のないキー、合計を確認する。
5. dbtを使う場合は `source()` と `ref()` で正本と派生モデルをつなぎ、必要な一意性、関係、突合の条件を検証する。
6. Obsidianノートには[frontmatterとタグの規約](../CANON.md#obsidian-note-metadata)を適用し、想定したプロパティやタグで探せることを確認する。

設計した契約と、実際のレコードやクエリで確かめた結果を示す。

## 関連ミッション

[自律文書整備](../MISSION.md#mission-documentation)

## 参照資料

- [Industrial Ontologies Foundry・IOF Ontology Portal](../CANON.md#canon-iof-ontology)
- [Palantir Foundry・Ontology](../CANON.md#canon-foundry-ontology)
- [Palantir Foundry・Data Lineage](../CANON.md#canon-foundry-data-lineage)
- [Microsoft Learn・スター・スキーマ](../CANON.md#canon-microsoft-star-schema)
- [Kimball Group・ファクトの粒度](../CANON.md#canon-kimball-grain)
- [W3C・PROV-O 来歴の標準](../CANON.md#canon-w3c-prov-o)
- [W3C・DCAT 3 データカタログの標準](../CANON.md#canon-w3c-dcat)
- [dbt Developer Hub・dbtの概要](../CANON.md#canon-dbt-introduction)
- [dbt・ソースと来歴](../CANON.md#canon-dbt-sources)
- [dbt・データ品質テスト](../CANON.md#canon-dbt-data-tests)
- [Pydantic・検証の公式ドキュメント](../CANON.md#canon-pydantic)
- [Microsoft・General Naming Conventions](../CANON.md#canon-general-naming)
- [Obsidian・Properties](../CANON.md#canon-obsidian-properties)
- [Obsidian・Tags](../CANON.md#canon-obsidian-tags)
- [かふかのZenn記事一覧](../CANON.md#canon-kafka-zenn)
- [imoz・日本語の文章編集ガイド](../CANON.md#canon-humanizer-ja)
