---
trigger: always_on
type: "policy"
description: "Antigravity CLIのセッションで配布版の作業規約とスキルを使う。"
tags:
  - kafstyler/policy
  - kafstyler/plugin
---

# Antigravity CLIの作業規約

1. **作業規約を開く。** 成果物を届ける最初の依頼で、このプラグインに同梱された[作業規約](../AGENTS.md)を読む。GitHubから導入した場合の既定の場所は `~/.gemini/config/plugins/kafstyler/AGENTS.md`。別の場所にある場合は `agy plugin list --json` で `kafstyler` の `path` を確認し、その配下の `AGENTS.md` を開く。
2. **常時稼働の中核を使う。** 定時・イベント・再開・長時間の仕事では `autocatalyze` を中核に、起動・状態復元・案件選定・委譲・実行・成果検証・停止・次回への引き継ぎを統括する。常時稼働はLLMの連続実行ではない。
3. **合格条件を決める。** 着手前に `reconceptualize` で利用経路と合格条件を決める。
4. **該当するスキルを使う。** 依頼と工程に該当する同梱スキルを選び、各 `SKILL.md` の手順で実行する。規約とスキルを委譲先に渡す場合も、同じ配布版を使う。

利用者が直接指定する場合の入口は `/reconceptualize` や `/autocatalyze`。
