---
name: autocatalyze
description: "案件の選定・実装・公開・継続を担う。"
---

# 自律開発

既存のIssue、MISSION、利用状況から価値の高い仕事を選び、認可範囲で実装・公開し、続きがあれば既存の正本へ残す。

## MISSIONに沿ったIssue駆動

目的、既存Issue、障害、依存、費用を読み、必要な仕事を選んで実行する。不要なIssueと重複する仕事は整理する。

## 破壊的移行の実行

正本と保持するデータを定め、後継へ切り替え、旧経路を廃止する。

## 常時稼働エージェントの中核

差分のない仕事は起動しない。既存起動基盤を使い、状態は既存Issue・実行履歴に結ぶ。失敗は即停止し、原因を示す。

## 常駐エージェントと定期実行

既存のOS・イベント・Orcaの起動元を選び、二重起動を防ぐ。必要な入力・認可・出力先だけ設定する。

## 外部ツールによるゼロトークン保守

[Vault保守](../../scripts/vault-maintenance.sh)で `OBSIDIAN_VAULT_PATH` を指定して実行する。`KAFSTYLER_INGEST_SOURCE` を必要時に設定する。非Git Vaultは `KAFSTYLER_VAULT_MODE=plain` を明示する。rclone、Knowledge Compiler、OSに処理を任せる。

## 外部Skillを優先して実行する

必要な公式Skill、既存CLI・MCPを使う。Orcaでは `orca skills get <topic> --full` で実行版の手順を得る。外部手順を複製しない。

## Orca機能を選んで使う

単発は既存端末、定期はAutomations、外部受付はBots、複数担当の連絡はOrchestrationを使う。

## Orcaで監督して実行する

[接続手順](../../integrations/orca/README.md)を使い、同じmainの書き込みを直列化する。

## OrcaのAutomationsとBotsを使う

既存のworkspaceと起動経路を使い、必要なイベントだけ受け付ける。実行失敗を無変化に変えない。認可範囲を守る。

## Orca Botの受付・進捗と判断待ち

依頼を既存の担当に渡し、本人しか解決できない権限・判断だけを提示する。

## Orcaの横断運用

複数ホストでも正本と単一書き手を維持する。

## Claude Codeの /loop 連携

既存の定期・イベント経路がある場合はそちらを使う。

## Claude Agent SDKでの実装

既存のSDKと公式手順を使う。

## 実装と公開

[共通規約](../../AGENTS.md)に従い、必要な変更をmainへコミットし、公開する。異常時は止め、未完了部分だけ引き継ぐ。

## 参照

[一次資料](../../BIBLES.md) · [共通規約](../../AGENTS.md#原則)
