---
description: "不要な文章、フォルダ、ファイル、スクリプト、コードを削り、重複する役割を統合する。AIスロップ削除、UNIX哲学に沿った整理に使う。"
---

# AIスロップ削除

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../CANON.md#canon-humanizer-ja)を適用する。[出力の共通基準](../MISSION.md#mission-output-style)

実装の整理に着手する前に、かふかのZenn記事[「なぜAIに任せるほど、あなたのコードは複雑になるのか」](https://zenn.dev/kafka2306/articles/2026-08-16-ai-added-decision-cost-audit)を読む。変更前後で、同じ判断を繰り返す分岐、同じ事実を別々に持つ状態、処理を渡すだけの中間層を確認し、フォルダの統合やファイルの削除に反映する。[聖典台帳の該当項目](../CANON.md#canon-kafka-ai-complexity)

1. 利用者が普段使う入口を特定し、ファイル、フォルダ、コードの参照元と実際の呼び出し元を確認する。
2. 同じ役割のフォルダを既存の管理先に統合する。未使用ファイル、空のフォルダ、重複したMarkdown、実行されないコード、処理を素通しするだけのPython・TypeScriptのラッパーを削除する。一つのプログラムに一つの仕事を持たせ、必要に応じて標準入出力でつなぐ。[評価結果](automated-evaluation.md)から置換済みの手順を割り出す。
3. 結論の繰り返し、意味の薄いバッジ、未使用のプレースホルダー、不要な作業説明、場当たり的な名称を削る。事実、行動に必要な指示、適用条件は該当箇所に残す。
4. 移動・削除したファイルのインポート、リンク、設定、呼び出し元を更新する。普段の利用経路で確認し、統合したフォルダ、削除したファイル、動作の根拠を示す。

## 関連ミッション

[自律改善](../MISSION.md#mission-improvement)・[自律文書整備](../MISSION.md#mission-documentation)・[外部手法への置き換え](../MISSION.md#mission-adopt-upstream)

## 参照資料

- [Anthropic・Agent Skills執筆ガイド](../CANON.md#canon-anthropic-skill-authoring)
- [imoz・日本語の文章編集ガイド](../CANON.md#canon-humanizer-ja)
- [McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](../CANON.md#canon-unix-philosophy)
- [かふかのZenn記事一覧](../CANON.md#canon-kafka-zenn)
