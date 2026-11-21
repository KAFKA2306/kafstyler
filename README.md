---
type: guide
description: "Kafstylerの導入と使い方"
---

# Kafstyler

AIの仕事を、利用者が使える成果まで進める7スキル。Claude Code、Codex、Antigravity CLIに対応します。

## 導入

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
agy plugin list --json
```

## まず一件試す

```text
このプロジェクトの検索機能を直して。
実際の画面で検索し、期待した結果が開けることまで確認して。
不要な仕組みは増やさず、変更と検証結果を示して。
```

仕事に合うスキルを選びます。Claude Codeでは `/kafstyler:decommission`、Codexでは `$decommission`、Antigravity CLIでは `/decommission` のように直接指定できます。

## 7スキル

| スキル | 役割 |
| --- | --- |
| [reconceptualize](skills/reconceptualize/SKILL.md) | 目的と完成条件 |
| [adjudicate](skills/adjudicate/SKILL.md) | 評価と採否 |
| [canonicalize](skills/canonicalize/SKILL.md) | 正本とデータ設計 |
| [didactization](skills/didactization/SKILL.md) | 知見と文章 |
| [disprove](skills/disprove/SKILL.md) | 反証レビュー |
| [decommission](skills/decommission/SKILL.md) | 不要なものの削除 |
| [autocatalyze](skills/autocatalyze/SKILL.md) | 自律実行と継続運用 |

定期・イベントによる継続作業は `autocatalyze` が統括します。全スキルの一律実行はしません。

## 正本・保守

[共通規約](AGENTS.md) · [ミッション](MISSION.md) · [一次資料](BIBLES.md)

モデル候補は `node .agents/select-models.mjs --baseline` で確認し、公開データから `node .agents/select-models.mjs --write` で更新します。配布変更後は、影響するCLIでスキルが見つかり、目的の操作が完了するか確かめます。フックの承認は不要です。
