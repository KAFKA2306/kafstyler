---
type: reference
description: "自律実行・監督・状態の継承に使う設計原理"
tags:
  - kafstyler/canon
---
# エージェント設計

## 実行と停止
- [Anthropic・Building effective AI agents](https://www.anthropic.com/research/building-effective-agents)：最小の構成から始め、決定的な手順と自律判断を分ける。
- [Anthropic・Trustworthy agents in practice](https://www.anthropic.com/research/trustworthy-agents)：自律性と委任範囲を区別する。
- [Chenほか・Knowing When to Stop: The Evidence-Action Gap in Coding Agents](https://arxiv.org/abs/2610.31895)：障害の証拠と再試行・引き継ぎの判断を結ぶ。
- [Gloaguenほか・Coding Agents Don't Know When to Act](https://www.sri.inf.ethz.ch/publications/gloaguen2026coding)：介入すべき条件を考える。
- [Jeongほか・TIDE: Proactive Multi-Problem Discovery via Template-Guided Iteration](https://arxiv.org/abs/2606.04743)：複数の問題を発見する探索の原理を参照する。
- [Anthropic・Measuring AI agent autonomy in practice](https://www.anthropic.com/research/measuring-agent-autonomy)：自律性を稼働時間だけでなく介入条件から捉える。

## ハーネスと状態の継承
- [Anthropic・Effective harnesses for long-running agents](https://www.anthropic.com/research/effective-harnesses-for-long-running-agents)：セッションの外に進捗と成果を保持する。
- [OpenAI・Harness engineering](https://openai.com/index/harness-engineering/)：エージェントが必要な文脈を環境から得られる構造を作る。
- [Anthropic・Effective context engineering for AI agents](https://www.anthropic.com/research/effective-context-engineering-for-ai-agents)：文脈の選択、圧縮、引き継ぎを設計する。
- [Anthropic・The components of agent memory](https://www.anthropic.com/research/components-of-agent-memory)：記憶の役割と保持条件を区別する。
- [Anthropic・Scaling Managed Agents with stable interfaces](https://www.anthropic.com/research/managed-agents)：状態と実行環境の分離という設計原理を参照する。
- [Anthropic・Building always-on agents](https://claude.com/resources/articles/building-always-on-agents)：イベント、記憶、権限、通知を分離する。
- [Chip Huyen・AI Engineering](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)：AIシステムの目的、制約、構成を考える。
- [Manning・Agent Engineering](https://www.manning.com/books/agent-engineering)：エージェントシステムの設計方法を参照する。

## 監督と障害
- [Erlang/OTP・Supervisor Principles](https://www.erlang.org/doc/system/sup_princ.html)：実行者と監督者を分離し、再起動の範囲を制御する。
- [AWS・Making retries safe with idempotent APIs](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/)：再試行による二重反映を防ぐ。
- [Google SRE・Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)：内部の稼働と利用者に現れる症状を区別する。
