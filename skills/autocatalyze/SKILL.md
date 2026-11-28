---
name: autocatalyze
description: "MISSIONから仕事を自律選定し実装・制作・公開まで進める。定時・イベント・中断再開・既存エージェントの監督を担う。"
---

# 自律実行

認可範囲で価値のある仕事を完了まで進める。計画やIssue起票だけを成果にしない。[共通規約](../../AGENTS.md) に従う。

## 判断の根拠

[MISSION](../../MISSION.md) を目的、[AGENTS.md](../../AGENTS.md) を共通規約とする。

- [かふかの原典](../../bibles/kafka-zenn.md)：次に解くべき一件を選び、Issue駆動で引き継ぎ、Crash-Driven Developmentに従って失敗を隠さず止める。
- [エージェント設計](../../bibles/agents-and-orca.md)：Anthropicの最小構成・委任範囲・状態継承、Erlang/OTPの監督原則、AWSの冪等性から、実行・監督・再開方法を選ぶ。
- [開発の原理](../../bibles/dev-infra-and-3d.md)：UNIXの責務分離、DORAの主線統合、Google SREのToil削減を運用設計に用いる。

その他は [聖典台帳](../../BIBLES.md) の該当原典を適用条件と限界に応じて参照する。原典は共通規約を上書きしない。

## 一件を成果まで進める

1. MISSION、目的、既存Issue、実績、障害から仕事を選ぶ。未依頼の根本問題も [reconceptualize](../reconceptualize/SKILL.md) で扱う。重複案件を増やさず、価値の低い変更は選ばない。
2. 対象、仕様、成果、入力、権限、費用、書き手を特定する。[canonicalize](../canonicalize/SKILL.md) の参照を使い、既存担当・作業場所を再利用する。書き手やworktreeを増やさない。
3. 利用可能な正規の実行入口・入力・権限・更新契約を具体的に確認し、実行できる仕事から着手する。既存CLI、公式Skill、外部標準ツール、miseを使い、未知の操作だけ [実行索引](../../COMMANDS.md) を読む。判断に必要なら [adjudicate](../adjudicate/SKILL.md)・[disprove](../disprove/SKILL.md) を使う。全Skillを機械的に起動しない。
4. 成果を実装・制作し、認可済み公開先まで届ける。破壊的移行は正本・利用者データ・出典・識別子・履歴を守り、切り替えと旧経路廃止を [decommission](../decommission/SKILL.md) と進める。文章は [didactization](../didactization/SKILL.md) を使う。
5. 共通Git規約に従いmainへ非強制更新する。完了した既存Issueは閉じ、未完了なら原因と再開条件を残す。独立した完了判定工程を作らない。

## 常駐・定期・イベント・再開

- 起動：既存OSスケジューラ、イベント、常駐基盤を用いる。定期保守と毎回の調査・制作を区別する。正本への書込みを直列化し、権限・費用・期限を引き継ぐ。
- 差分：取得→ID・更新識別子による差分判定→必要な処理→反映→必要な通知。機械処理はCLI・OS・数式、定型判断は低コストモデル、難しい判断は高知能モデル。取得成功かつ差分なしならnoop。失敗なら停止し、古い出力を最新に見せない。外部CLIで済むなら自作しない。
- 再開：既存案件と正本から最後に反映された成果、未完了工程、判断待ちを読み、未完了箇所から続ける。応答途絶時は反映済みかを外部状態から判断し二重処理を避ける。
- 障害：必須入力・依存・権限・実行失敗は即停止し、原因を隠さない。停止は影響する処理だけ。共通規約の障害解消・再開手順を実行し、解消不能なら同一実行内に独立した成果へ切り替える。原因の変化がない失敗案件を繰り返し選ばない。認可・使命変更など人間にしか決められない問いは具体化して既存受付経路へ渡し、独立案件は続ける。
- 監督：既存セッションの状態、担当、進捗、障害、判断待ちを読む。正常な担当へ余計な指示を送らない。必要な場合だけ認可済み担当に具体的な再開指示を渡し、競合する担当を増やさない。

## 実行入口

- Orca：既存Workspaceとcheckoutを使い、mise run orca-preflight --repo PATH を書込み前の実行契約とする。Automations、Bots、Orchestration、Needs youは既存経路を再利用する。
- Claude Code、Codex、Antigravity、公式Skill、tj-loop、agent-sessions：起動・再開・監督は [エージェント実行契約](../../commands/agents.md)。既存セッションIDを保持し別の仕組みを重ねない。
- [知識取り込み・保守](../../commands/knowledge.md)、[開発・配布](../../commands/development.md)、[制作・公開](../../commands/production.md)。未認可の有料生成や公開は行わない。

返すものは実際の成果と参照先、残る仕事、障害・再開条件。
