---
name: clean
type: "skill"
description: "不要な文章、フォルダ、ファイル、スクリプト、コードを削り、重複する役割を統合する。AIスロップ削除、UNIX哲学に沿った整理に使う。"
tags:
  - kafstyler/skill
  - kafstyler/skill/clean
aliases:
  - "AIスロップ削除"
  - "整理"
---

# AIスロップ削除

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../../BIBLES.md#imozの日本語編集)を適用する。[出力の共通基準](../../MISSION.md#出力の共通基準)

着手前に、かふかのZenn記事を3本読み、対象に当てはまる整理基準を選ぶ。

- [なぜAIに任せるほど、あなたのコードは複雑になるのか](https://zenn.dev/kafka2306/articles/2026-08-16-ai-added-decision-cost-audit) 重複する指示・検証・状態・分岐を洗い出し、削除後も機能・正しさ・必要な証拠が揃うかを確かめる。 [聖典台帳](../../BIBLES.md#aiが増やす判断箇所)
- [AIに同じ指示を繰り返すのをやめた。Issue駆動開発という最小運用](https://zenn.dev/kafka2306/articles/issue-driven-development) 終わった変更の経緯をIssueに残し、現在の仕様として必要な記述を正本に集約する。 [聖典台帳](../../BIBLES.md#issue駆動開発)
- [AIを「過保護」にするな。スタックトレースを聖典とする開発規律 "Crash-Driven Development"](https://zenn.dev/kafka2306/articles/11cd731eebded1) 障害の原因を隠す広すぎる例外捕捉やフォールバックを見直し、根本原因を観測できる形にする。 [聖典台帳](../../BIBLES.md#失敗原因が見える実装)

1. 利用者が普段使う入口を特定し、ファイル、フォルダ、コードの参照元と実際の呼び出し元を確認する。挙動の比較が必要なら、削除前に普段の入口、入力、観測した結果を記録する。
2. 同じ役割のフォルダを既存の管理先に統合する。未使用ファイル、空のフォルダ、重複したMarkdown、実行されないコード、処理を素通しするだけのPython・TypeScriptのラッパーを削除する。一つのプログラムに一つの仕事を持たせ、必要に応じて標準入出力でつなぐ。既存の[評価結果](../test/SKILL.md)があれば、置換済みの手順を割り出すために使う。
3. 結論の繰り返し、意味の薄いバッジ、未使用のプレースホルダー、不要な作業説明、場当たり的な名称を削る。事実、行動に必要な指示、適用条件は該当箇所に残す。
4. 移動・削除したファイルのインポート、リンク、設定、呼び出し元を更新する。普段の利用経路で確認する。削除前後の挙動を比較する必要があり、同じ確認の結果がまだなければ、Claude Codeの `Skill` ツールで [`kafstyler:test`](../test/SKILL.md) を呼ぶ。対象の入口、削除前の入力と観測結果、合格条件、変更範囲を `args` に渡す。統合したフォルダ、削除したファイル、動作の根拠を示す。

## 関連ミッション

[自律改善](../../MISSION.md#自律改善)・[自律文書整備](../../MISSION.md#自律文書整備)・[外部手法への置き換え](../../MISSION.md#外部実装への置き換え)

## 参照資料

- [Anthropic・Agent Skills執筆ガイド](../../BIBLES.md#スキルの執筆)
- [imoz・日本語の文章編集ガイド](../../BIBLES.md#imozの日本語編集)
- [McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](../../BIBLES.md#unix哲学)
- [かふかのZenn記事一覧](../../BIBLES.md#かふかのzenn記事一覧)
- [エージェント向けのフォルダ整理](../../BIBLES.md#エージェント向けのフォルダ整理)
- [astralのpython開発基盤](../../BIBLES.md#astralのpython開発基盤)
- [taskで共通の実行手順を作る](../../BIBLES.md#taskで共通の実行手順を作る)
