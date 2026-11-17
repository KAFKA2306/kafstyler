---
name: data
type: "skill"
description: "エンティティ、オントロジー、メタデータ、台帳、マスター、スタースキーマ、dbtのデータ構造を設計する。"
tags:
  - kafstyler/skill
  - kafstyler/skill/data
aliases:
  - "データ設計"
  - "台帳設計"
---

# データ設計

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../../BIBLES.md#imozの日本語編集)を適用する。[出力の共通基準](../../MISSION.md#出力の共通基準)

1. 答える問い、現行データの管理者、実際の入力を確かめる。エンティティの識別子、関係、操作を定義する。産業分野の概念にはIOF、業務オブジェクトにはFoundryの設計を必要に応じて参照する。
2. 検索、判断、検証に使う項目を選ぶ。必要に応じて出典ID、URL、時点、版、単位、欠損値の意味、来歴を持たせる。名前はプロジェクトで使われている語彙から選ぶ。
3. 台帳は一行のキー、状態遷移、訂正履歴を定め、再入力時の照合方法を決める。マスターは識別子、正とする属性、必要に応じて有効期間を定める。
4. 分析では最初にファクトの一行が表す粒度を定める。粒度ごとに集計し、結合後の件数増加、対応先のないキー、合計を確認する。
5. dbtを使う場合は `source()` と `ref()` で正本と派生モデルをつなぎ、必要な一意性、関係、突合の条件を検証する。
6. Obsidianノートには[frontmatterとタグの規約](../../BIBLES.md#ノートの管理)を適用し、想定したプロパティやタグで探せることを確認する。

設計した契約と、実際のレコードやクエリで確かめた結果を示す。

## 関連ミッション

[自律文書整備](../../MISSION.md#自律文書整備)

## 参照資料

- [Industrial Ontologies Foundry・IOF Ontology Portal](../../BIBLES.md#産業オントロジー)
- [Palantir Foundry・Ontology](../../BIBLES.md#foundryのオントロジー)
- [Palantir Foundry・Data Lineage](../../BIBLES.md#foundryのデータ来歴)
- [Microsoft Learn・スター・スキーマ](../../BIBLES.md#スタースキーマ)
- [Kimball Group・ファクトの粒度](../../BIBLES.md#ファクトの粒度)
- [W3C・PROV-O 来歴の標準](../../BIBLES.md#来歴の標準)
- [W3C・DCAT 3 データカタログの標準](../../BIBLES.md#データカタログの標準)
- [dbt Developer Hub・dbtの概要](../../BIBLES.md#dbtの概要)
- [dbt・ソースと来歴](../../BIBLES.md#dbtのソース)
- [dbt・データ品質テスト](../../BIBLES.md#dbtのデータテスト)
- [Pydantic・検証の公式ドキュメント](../../BIBLES.md#pydanticのデータ検証)
- [Microsoft・General Naming Conventions](../../BIBLES.md#命名規則)
- [Obsidian・Properties](../../BIBLES.md#obsidianのプロパティ)
- [Obsidian・Tags](../../BIBLES.md#obsidianのタグ)
- [かふかのZenn記事一覧](../../BIBLES.md#かふかのzenn記事一覧)
- [imoz・日本語の文章編集ガイド](../../BIBLES.md#imozの日本語編集)
- [Obsidian・保管庫の作成](../../BIBLES.md#obsidianの保管庫)
- [Obsidian・内部リンク](../../BIBLES.md#obsidianの内部リンク)
