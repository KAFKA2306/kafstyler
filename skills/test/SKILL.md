---
name: test
type: "skill"
description: "再実行できる条件で基準と候補を比較し、合格条件を確かめる。自動評価、回帰評価、採点に使う。"
tags:
  - kafstyler/skill
  - kafstyler/skill/test
aliases:
  - "自動評価"
  - "評価"
---

# 自動評価

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../../BIBLES.md#imozの日本語編集)を適用する。[出力の共通基準](../../MISSION.md#出力の共通基準)

1. 対象と重大な失敗を定める。指標ごとに入力、測定方法、単位、合格条件を実行前に決める。通常、境界、過去に失敗したケースを選び、[レビューの指摘](../critique/SKILL.md)も参照する。
2. 入力と版を固定し、基準と候補を同じ経路、費用上限、設定で実行する。
3. 観測できる結果は機械的に確認する。判断が必要な項目には具体的な採点基準を定め、既存の判定済み事例があれば採点者の結果を照合する。独立した評価では、成果物・入力・判定基準を渡し、実装者の結論は評価後に照合する。ばらつきが判断に効く実験は繰り返す。
4. ケースごとの結果、全体の差、失敗理由、再実行コマンドか原典を示す。必要に応じて所要時間と費用を添える。実測できなかった項目は未確認とする。

報告書や読者向けブリーフの作成まで依頼されている場合は、Claude Codeの `Skill` ツールで [`kafstyler:edit`](../edit/SKILL.md) を呼ぶ。`args` に原稿、読者、測定値、合否、未確認事項を渡し、校正した報告を返す。

呼び出し元がある場合は、合否と測定結果を元の作業へ返す。

## 関連ミッション

[自律改善](../../MISSION.md#自律改善)・[自律成果創出](../../MISSION.md#自律成果創出)・[評価指標](../../MISSION.md#機械的に確かめる評価指標)

## 参照資料

- [Anthropic・成功基準と評価の設計](../../BIBLES.md#成功基準と評価)
- [dbt・データ品質テスト](../../BIBLES.md#dbtのデータテスト)
- [Tripo / VAST AI・論文一覧](../../BIBLES.md#tripoの研究一覧)
- [TripoSR・単一画像からの3D復元](../../BIBLES.md#画像からの三次元復元)
- [TripoSG・高精細な3D形状生成](../../BIBLES.md#細部を保つ三次元形状生成)
- [SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](../../BIBLES.md#任意のトポロジーを持つ形状)
- [TripoSplat・密度を制御する3Dガウシアン生成](../../BIBLES.md#密度を制御する三次元生成)
- [AniGen・アニメーション可能な3Dアセット生成](../../BIBLES.md#動かせる三次元アセット)
- [Nexus・頂点とトポロジーを扱うメッシュ生成](../../BIBLES.md#頂点とトポロジーを扱うメッシュ生成)
- [OpenAI・Harness engineering](../../BIBLES.md#openaiのハーネス設計)
- [Anthropic・Effective harnesses for long-running agents](../../BIBLES.md#長時間稼働するエージェント)
- [Chip Huyen・AI Engineering](../../BIBLES.md#aiエンジニアリングの書籍)
- [Manning・Agent Engineering](../../BIBLES.md#エージェント設計の書籍)
- [かふかのZenn記事一覧](../../BIBLES.md#かふかのzenn記事一覧)
- [imoz・日本語の文章編集ガイド](../../BIBLES.md#imozの日本語編集)
- [ISUCON2026 で優勝しました（準備編）](../../BIBLES.md#isuconの準備)
- [fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](../../BIBLES.md#isuconの優勝ハーネス)
- [自動テストの合格条件](../../BIBLES.md#自動テストの合格条件)
- [外部実装の互換性と判定根拠](../../BIBLES.md#外部実装の互換性と判定根拠)
- [継続検証による技術監査](../../BIBLES.md#継続検証による技術監査)
- [完了を裏づける証拠](../../BIBLES.md#完了を裏づける証拠)
- [steamvrの起動障害](../../BIBLES.md#steamvrの起動障害)
- [windowsとwslの自動化](../../BIBLES.md#windowsとwslの自動化)
