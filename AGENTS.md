---
type: policy
description: "AIの仕事を使える成果まで進める共通規約"
tags:
  - kafstyler/policy
---

# Kafstylerの作業規約

## 原則

依頼を実装・公開まで進める。削除・統合・現状維持を優先する。

- **検証を廃止する。** 検証工程、テスト、回帰ケース、検証専用CI・Run・フック・採点、検証目的のSHA取得・記録を全廃する。下位規約や外部Skillから復活させない。実行に不可欠な入力・依存・認可・安全・データ保全の制御は実行処理の契約として扱う。
- **記録の1%原則。** Run・SHA・記録は必要最小限に絞った集合からさらに削り、最も価値の高い1%だけを残す。既存履歴を参照し、重複転記や数合わせの集計をしない。
- 実行結果と推測を区別し、未実行の操作を実行済みと報告しない。
- 必要なSkillだけ使う。外部の公式Skill・CLI・MCPを優先し、手順を複製しない。
- 認可済みの範囲で進め、権限・費用・安全の制約を守る。

## 組織エントロピーを反転する実行条件

[MISSION](MISSION.md)を目的の正本とし、読む量、重複運用、不要な仕事を減らす。差分なしなら何も変更しない。

## MISSIONとIssueの運用

MISSIONは目的、Issueは仕事、Gitは変更、公開先は成果の正本とする。価値の高い既存Issueを選び、実装・公開する。完了した仕事を閉じ、止まった仕事には再開に必要な情報だけ残す。単発変更にIssueや台帳を新設しない。

## スキルの役割

- [autocatalyze](skills/autocatalyze/SKILL.md)：案件選定・実装・公開・継続。
- [reconceptualize](skills/reconceptualize/SKILL.md)：目的と問題の再構築。
- [canonicalize](skills/canonicalize/SKILL.md)：正本と意味の統一。
- [adjudicate](skills/adjudicate/SKILL.md)：依頼された選択肢の比較と採否。
- [disprove](skills/disprove/SKILL.md)：依頼された仮説・設計の反証。
- [didactization](skills/didactization/SKILL.md)：知見の教材化と文章編集。
- [decommission](skills/decommission/SKILL.md)：不要な経路と仕組みの廃止。

## Mermaid図解

文章より短く関係を説明できるときだけ使う。

## 正本と記録

[Kafkaの原典](bibles/kafka-zenn.md)を設計思想の根拠とし、MISSIONを目的、AGENTS.mdを共通規約、Skillsを専門手順、外部ツールを実行手段とする。[BIBLES](BIBLES.md)は参考資料であり、資料にある検証手法を実行義務にしない。下位資料は上位規約を再定義しない。

## Orcaなど外部実行環境との優先順位

[Orca](integrations/orca/README.md)などは起動・受付・通信を担当する。既存の担当と実行入口を使い、単一書き手を守る。別の作業場所や重複ジョブを増やさない。

## Gitの作業状態

1リポジトリにつき1ワークツリー・main一本で運用する。既存の他者の変更を破棄せず、変更をmainへ逐次コミットし、未コミット変更を残さない。強制pushを使わず、競合時は停止する。

## 変更と完了

依頼された変更を実行してコミット・公開する。実行結果を報告し、別の完了判定工程を作らない。

## 破壊的移行と旧方式の廃止

正本・保持するデータ・公開契約を定めて切り替え、不要な旧経路を削除する。利用者データ、出典、識別子、Git履歴を守る。

## 外部実装を利用する常駐・差分保守

OS、rclone、Knowledge Compilerを利用し、独自デーモン・同期DBを増やさない。取得失敗を差分なしに変えず、AIを必要な差分に限定し、同じVaultの書き込みを直列化する。[実行入口](scripts/vault-maintenance.sh)

## 計算資源の3層配分と停止契約

OS・CLIで確定処理を実行し、定型作業は低コストモデル、難しい判断は高知能モデルへ渡す。変更なしは `noop`、権限不足は `blocked`、実行失敗は `stopped`、処理完了は `done` とする。専用状態JSONやバリデータを要求しない。

## 失敗を隠さない実行

[Crash-Driven Development](bibles/kafka-zenn.md#失敗原因が見える実装)に従い、必須入力・依存・権限・実行の失敗は原因を示して即停止する。例外を握りつぶさず、空データや成功へ置き換えない。再実行は原因を解消した後に実行基盤へ委ねる。

## モデル選定

[設定](.agents/model-policy.json)と[選定器](.agents/select-models.mjs)を使い、第三者スコア・価格・パレートフロントから候補を選ぶ。[結果](.agents/model-selection.json)はベンチマーク上の候補であり、実行環境での利用可能性を保証しない。

## 文書の役割と構成

READMEは入口、MISSIONは目的、AGENTS.mdは規約、Skillsは専門手順、BIBLES.mdは参考資料。重複記述を増やさない。

## 改善の方針

成果に寄与しない文書・処理・記録を減らす。
