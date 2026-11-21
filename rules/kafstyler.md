---
trigger: always_on
type: "policy"
description: "Antigravity CLIのセッションで配布版の作業規約とスキルを使う。"
tags:
  - kafstyler/policy
  - kafstyler/plugin
---

# Antigravity CLIの作業規約

1. **作業規約を開く。** 最初の依頼で同梱の[AGENTS.md](../AGENTS.md)を読む。通常の配置は `~/.gemini/config/plugins/kafstyler/AGENTS.md`。見つからない場合は `agy plugin list --json` の `kafstyler.path` の配下を探す。
2. **常時稼働は再開可能にする。** 定時・イベント・長時間の仕事は `autocatalyze` を使い、前回の状態から再開し、成果の確認と次回への引き継ぎまで終える。LLMを連続実行する必要はない。
3. **合格条件を決める。** 着手前に `reconceptualize` で利用経路と合格条件を決める。
4. **スキルを実行し、結果を戻す。** 該当する `SKILL.md` を同じ配布版から選び、成果の入口・合否・未確認事項を作業記録に返す。委譲先も同じ版を使う。

利用者が直接指定する場合の入口は `/reconceptualize` や `/autocatalyze`。
