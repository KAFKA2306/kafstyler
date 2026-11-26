---
type: guide
description: "目的別の実行入口"
tags:
  - kafstyler/operation
---

# 実行契約

認可済みの既知コマンドは直ちに実行。共通タスクはKafstylerの配置先で `mise run TASK ARGS`。未知のタスクだけ `mise tasks`、引数は `mise run TASK --help`。以下は不足する契約だけ読む。

## 知識とデータ
[知識・OKF・Vault・データ変換](commands/knowledge.md)。
### 知識の検索・整形・変換
[検索・変換](commands/knowledge.md#知識の検索整形変換)。

## エージェント・連携
[エージェント・MCP・Skill](commands/agents.md)。
### エージェントの起動・再開・拡張
[起動・再開](commands/agents.md#エージェントの起動再開拡張)。
### Orcaの操作契約
[Orca](commands/agents.md#orcaの操作契約)。

## 開発・実行・運用
[CLI・OS・配布](commands/development.md)。
### 開発・OS・配布の具体操作
[操作](commands/development.md#開発os配布の具体操作)。

## 制作・公開・分析
[制作・公開・分析](commands/production.md)。
### 制作・公開・情報収集の具体操作
[操作](commands/production.md#制作公開情報収集の具体操作)。
### 制作APIの入出力
[ComfyUI・Tripo](commands/production.md#制作apiの入出力)。

既存CLI・公式Skill・miseを再利用し、版・契約の変更時だけ上流を読む。ホスト設定・秘密・費用認可は利用先に置く。不足時は停止する。新規操作は該当契約だけに追加する。
