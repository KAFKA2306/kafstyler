---
type: guide
description: "常時稼働エージェントの設計思想、7 Skillsの責務、引き継ぎと運用、導入方法。"
tags:
  - kafstyler/guide
---

# Kafstyler

一人の構想を永続的な知能機関へ変える7 Skills。目的と正本を共有し、実装・公開を継続する。

## Kafstylerが変えること

AI・端末・案件が増えても仕事を重複させない。外部の標準機能を使い、不要になった仕組みを廃止する。

## MISSION駆動・Issue駆動

[MISSION](MISSION.md)は目的、Issueは仕事、Gitは実装、公開先は成果の正本とする。

## 外部ツールで回す日常保守

OS、rclone、Knowledge Compilerに差分取得とVault整形を任せる。WSL等では `OBSIDIAN_VAULT_PATH` を指定して [Vault保守](scripts/vault-maintenance.sh) を実行する。必要時だけ `KAFSTYLER_INGEST_SOURCE` を指定し、非Git Vaultは `KAFSTYLER_VAULT_MODE=plain` を明示する。

## なぜこの7 Skillsなのか

実行の責任をautocatalyzeに集め、異なる専門判断だけを分ける。

### 7 Skillsを分ける理由

| Skill | 責務 |
| --- | --- |
| [autocatalyze](skills/autocatalyze/SKILL.md) | 案件選定、実装、公開、継続 |
| [reconceptualize](skills/reconceptualize/SKILL.md) | 目的と問題の再構築 |
| [canonicalize](skills/canonicalize/SKILL.md) | 正本と意味の統一 |
| [adjudicate](skills/adjudicate/SKILL.md) | 依頼された選択肢の比較と採否 |
| [disprove](skills/disprove/SKILL.md) | 依頼された仮説・設計の反証 |
| [didactization](skills/didactization/SKILL.md) | 知見の教材化、文章編集 |
| [decommission](skills/decommission/SKILL.md) | 不要な経路と仕組みの廃止 |

## 常時稼働エージェントの中核

既存のスケジューラー、イベント、Orcaを利用し、変化のない仕事は起動しない。失敗は原因を示して即停止する。

## 大規模な開発を支える仕組み

### 7つのSkillが連関して成果を出す

autocatalyzeが仕事を進め、必要な専門Skillだけを呼ぶ。全Skillを一律に実行しない。

## canonicalizeが大規模運用の共通基盤をつくる

既存のIssue、Git、文書、公開先を参照し、正本を重複させない。

## decommissionが常時稼働の実行力を守る

旧経路、重複ジョブ、不要な記録を減らす。

## まず一件試す

autocatalyzeで対象リポジトリの重要なIssueを選び、実装・公開する。残る仕事だけ既存Issueに記す。

## プラグインの使い方

### Claude Code

```sh
claude plugin install kafstyler --marketplace KAFKA2306/agent-resources --scope user
```

[配布元](https://github.com/KAFKA2306/agent-resources/blob/main/.claude-plugin/marketplace.json)

### Codex

```sh
codex plugin marketplace add KAFKA2306/kafstyler
codex plugin add kafstyler@kafstyler
```

### Antigravity CLI

```sh
agy plugin install https://github.com/KAFKA2306/kafstyler
```

### Orca

[接続手順](integrations/orca/README.md)から既存のAgents・Skills・Automations・Botsを利用する。main一本・単一書き手を守る。

### 依頼を送って使う

Claude Codeでは `/kafstyler:autocatalyze`、Codexでは `$autocatalyze`、Antigravity CLIでは `/autocatalyze` を使う。

### プラグインの更新

Claude Codeは `claude plugin update kafstyler@kafka-agent-tools`、Codexは `codex plugin marketplace upgrade kafstyler` を使う。

## 成果から使い方を選ぶ

### 開発・運用

[agent-resources](https://github.com/KAFKA2306/agent-resources) · [design](https://github.com/KAFKA2306/design)

### 記事・動画・音声

[didactization](skills/didactization/SKILL.md)で知見を公開する。

### VRChat・3D・画像制作

[image2outfit](https://github.com/KAFKA2306/image2outfit) · [技術資料](bibles/dev-infra-and-3d.md)

### ボードゲーム・ゲーム

目的に必要な設計と実装を進める。

### 企業・市場の調査

[金融と市場](bibles/finance-and-markets.md)

### 科学・製造の調査

一次資料から知見を整理する。

### Kaggle

目的に沿って既存ツールとデータを利用する。

### 暮らしと学習

必要な知識と手順を整理する。

## スキル

[共通規約](AGENTS.md#スキルの役割)を参照する。

## Unity・VRChatで制作する

[開発基盤・3D](bibles/dev-infra-and-3d.md)を参照する。

## 外部スキルとテンプレート

公式Skillと既存テンプレートを優先し、複製しない。

### 成果物の根拠調査と推敲

[didactization](skills/didactization/SKILL.md)

### Googleのフロントエンド設計スキル

[設計とUI](bibles/design-and-ui.md)

### ComfyUIのワークフローテンプレート

[開発基盤・3D](bibles/dev-infra-and-3d.md)

## ミッション・聖典・作業規約

[MISSION](MISSION.md) · [BIBLES](BIBLES.md) · [AGENTS](AGENTS.md) · [目次](index.md)
