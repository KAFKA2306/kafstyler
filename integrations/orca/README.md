---
type: guide
description: "Orca BotsからKafstylerの7 Skillsへ案件を安全に渡す実行入口"
tags:
  - kafstyler/integration
  - kafstyler/orca
---

# Orca BotsとKafstylerの接続

Orcaは受付・起動・通信を担当する。案件の選定・実装・公開はautocatalyze、正本と再開はcanonicalizeが担当する。

## ホストでの接続

OrcaのSettingsからCLIを有効化し、既存Skillsを使う。Botsで受付を設定し、認可されたGitHub Connectorを接続する。公式手順は[Orca Docs](https://orca.dev/docs)を使う。

## Botの最初のメッセージ

KafstylerのAGENTS.mdとMISSION.mdに従い、必要なSkillだけ使用する。既存mainを一担当に割り当て、別worktree・ブランチ・重複ジョブを作らない。権限外では停止する。

## 既存mainへ書き込む前の安全制御

書き込みは[共通規約](../../AGENTS.md#gitの作業状態)に従う。[書き込みガード](../../scripts/orca-preflight.py)はローカル状態の制御であり、別ホストとの排他を取得しない。

## 監督付き委譲

必要時だけ公式Orchestrationで既存checkoutへ委譲し、権限・状態・再開先を既存の記録から引き継ぐ。

[公式Bot接続](https://orca.dev/docs/bots) · [公式Orchestration](https://orca.dev/docs/cli/orchestration)
