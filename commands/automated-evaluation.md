---
description: "再実行できる条件で基準と候補を比較し、合格条件を確かめる。自動評価、回帰評価、採点に使う。"
---

# 自動評価

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../CANON.md#canon-humanizer-ja)を適用する。[出力の共通基準](../MISSION.md#mission-output-style)

1. 対象と重大な失敗を定める。指標ごとに入力、測定方法、単位、合格条件を実行前に決める。通常、境界、過去に失敗したケースを選び、[レビューの指摘](devils-advocate.md)も参照する。
2. 入力と版を固定し、基準と候補を同じ経路、費用上限、設定で実行する。
3. 観測できる結果は機械的に確認する。判断が必要な項目には具体的な採点基準を定め、既存の判定済み事例があれば採点者の結果を照合する。ばらつきが判断に効く実験は繰り返す。
4. ケースごとの結果、全体の差、失敗理由、再実行コマンドか原典を示す。必要に応じて所要時間と費用を添える。実測できなかった項目は未確認とする。

結果を[採用](autonomous-development.md)と[旧手順の整理](remove-ai-slop.md)に使う。

## 関連ミッション

[自律改善](../MISSION.md#mission-improvement)・[自律成果創出](../MISSION.md#mission-delivery)・[評価指標](../MISSION.md#mission-evaluation)

## 参照資料

- [Anthropic・成功基準と評価の設計](../CANON.md#canon-anthropic-evaluation)
- [dbt・データ品質テスト](../CANON.md#canon-dbt-data-tests)
- [Tripo / VAST AI・論文一覧](../CANON.md#canon-tripo-publications)
- [TripoSR・単一画像からの3D復元](../CANON.md#canon-tripo-sr)
- [TripoSG・高精細な3D形状生成](../CANON.md#canon-tripo-sg)
- [SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](../CANON.md#canon-tripo-sparseflex)
- [TripoSplat・密度を制御する3Dガウシアン生成](../CANON.md#canon-tripo-splat)
- [AniGen・アニメーション可能な3Dアセット生成](../CANON.md#canon-tripo-anigen)
- [Nexus・頂点とトポロジーを扱うメッシュ生成](../CANON.md#canon-tripo-nexus)
- [OpenAI・Harness engineering](../CANON.md#canon-openai-harness-engineering)
- [Anthropic・Effective harnesses for long-running agents](../CANON.md#canon-anthropic-long-running-harness)
- [Chip Huyen・AI Engineering](../CANON.md#canon-chip-huyen-ai-engineering)
- [Manning・Agent Engineering](../CANON.md#canon-manning-agent-engineering)
- [かふかのZenn記事一覧](../CANON.md#canon-kafka-zenn)
- [imoz・日本語の文章編集ガイド](../CANON.md#canon-humanizer-ja)
