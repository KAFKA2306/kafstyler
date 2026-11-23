---
type: reference
description: "開発基盤と3Dの一次資料と判断基準"
tags:
  - kafstyler/canon
  - kafstyler/reference
---

# 開発基盤と3D

## CLI・開発・インフラ

### Gitの作業状態と完了

[DORA・Trunk-based development](https://dora.dev/capabilities/trunk-based-development/)（DORAの開発指針）。小さな変更を共通の主ブランチへ頻繁に統合し、長期間の分岐で差分を滞留させない。DORAはブランチ1本を必須としていない。Kafstylerの1ブランチ運用は、未回収の作業を増やさないための運用上の選択。

[Git・git-worktree](https://git-scm.com/docs/git-worktree)（公式リファレンス）。`git worktree list --porcelain` で作業場所を特定し、不要な追加worktreeは内容を確認後に `git worktree remove` で整理する。

[Git・git-branch](https://git-scm.com/docs/git-branch)（公式リファレンス）。`git branch --list` でローカルのブランチを確かめ、採用すべき差分が残っていないことを確認して整理する。

[Git・git-status](https://git-scm.com/docs/git-status)（公式リファレンス）。`git status --porcelain=v1 -uall` でステージ済み・未ステージ・未追跡の変更を確認する。出力が空ならGitが追跡する作業状態はクリーン。無視されたファイルは別途管理対象を判断する。

[Git・git-commit](https://git-scm.com/docs/git-commit)（公式リファレンス）。検証済みの変更を説明可能な単位で履歴に記録する。[Anthropic・長時間稼働するエージェント](agents-and-orca.md#長時間稼働するエージェント) は、セッション終了時にコミットと進捗情報を残す運用の実験的根拠。

[共通規約](../AGENTS.md#gitの作業状態) · [自律開発](../skills/autocatalyze/SKILL.md#実装と検証) · [作業状態の引き継ぎ](../skills/canonicalize/SKILL.md)

### UNIX哲学

[McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](https://doi.org/10.1002/j.1538-7305.1978.tb02135.x)（原典）。一つのプログラムに一つの仕事を任せ、入出力でつなぐ

[自律開発](../skills/autocatalyze/SKILL.md) · [不要なファイル・コード・文章の削除](../skills/decommission/SKILL.md)

### Pydanticのデータ検証

[Pydantic・検証の公式ドキュメント](https://pydantic.dev/docs/validation/latest/get-started/)（公式ドキュメント）。データの型と入力値の検証

[データ設計](../skills/canonicalize/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md)

### uvの環境管理

[Astral・uv](https://docs.astral.sh/uv/)（公式ドキュメント）。Pythonの環境と依存関係

[自律開発](../skills/autocatalyze/SKILL.md)

### Ruffの静的解析

[Astral・Ruff](https://docs.astral.sh/ruff/)（公式ドキュメント）。Pythonのlintと整形

[自律開発](../skills/autocatalyze/SKILL.md)

### tyの型検査

[Astral・ty](https://docs.astral.sh/ty/)（公式ドキュメント）。Pythonの型検査

[自律開発](../skills/autocatalyze/SKILL.md)

### Pulumiの構成管理

[Pulumi・Infrastructure as Code](https://www.pulumi.com/docs/iac/)（公式ドキュメント）。インフラ構成の実装

[自律開発](../skills/autocatalyze/SKILL.md)

### Pulumiの差分確認

[Pulumi・変更の事前確認（pulumi preview）](https://www.pulumi.com/docs/iac/cli/commands/pulumi_preview/)（公式手順）。インフラ変更の適用前確認

[自律開発](../skills/autocatalyze/SKILL.md)


## ユニティとVRChatの制作ツール

用途ごとに1本を選定。Starsは2026-11-17にGitHubで取得した値。

### ユニティの汎用MCP

[汎用Unity・CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp)（開発元実装）。シーン、アセット、テスト、ビルドを扱う50のMCPツール。MIT。GitHub Stars 16,030。

[自律開発](../skills/autocatalyze/SKILL.md)

### VRChatのワールド制作

[VRChat Worlds・swax/UnityMCP-VRC](https://github.com/swax/UnityMCP-VRC)（開発元実装）。UdonSharpの補助とエディター画面の確認。GitHub Stars 73。CC BY-NC 4.0のため、BOOTH向けなどの商用制作では利用条件を事前に確認する。[ライセンス原文](https://github.com/swax/UnityMCP-VRC/blob/main/LICENSE)

[自律開発](../skills/autocatalyze/SKILL.md)

### VRChatのアバター制作

[VRChat Avatars・lighfu/unity-agent](https://github.com/lighfu/unity-agent)（開発元実装）。READMEに400以上の操作ツールとComfyUI連携を記載。Avatar Descriptorの検査、PhysBoneの設定、Modular Avatarによる衣装導入、SDKビルドとアップロードを扱う。MIT。GitHub Stars 45。[衣装導入手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/modular-avatar.md)・[SDKビルド手順](https://github.com/lighfu/unity-agent/blob/master/Editor/Skills/avatar-build.md)

[自律開発](../skills/autocatalyze/SKILL.md)


## Tripoと3D生成

### Tripo Studio

[Tripo Studio・公式ドキュメント](https://www.tripo3d.ai/product-doc)（公式ドキュメント）。Studioでの制作

[自律開発](../skills/autocatalyze/SKILL.md)

### TripoのAPI

[Tripo API・公式ドキュメント](https://developers.tripo3d.ai/en/docs/introduction)（公式ドキュメント）。APIを使った生成処理

[自律開発](../skills/autocatalyze/SKILL.md)

### TripoのComfyUI連携

[Tripo・ComfyUIノードの公式ドキュメント](https://developers.tripo3d.ai/en/docs/comfyui-nodes)（公式ドキュメント）。ComfyUIでのノード設定

[自律開発](../skills/autocatalyze/SKILL.md)

### Tripoの研究一覧

[Tripo / VAST AI・論文一覧](https://www.tripo3d.ai/research/publications)（論文一覧）。関連する手法の検索

[自律開発](../skills/autocatalyze/SKILL.md) · [評価と比較](../skills/adjudicate/SKILL.md)

### 画像からの三次元復元

[TripoSR・単一画像からの3D復元](https://arxiv.org/abs/2403.02151)（技術報告）。単一画像からの3D復元

[評価と比較](../skills/adjudicate/SKILL.md)

### 細部を保つ三次元形状生成

[TripoSG・高精細な3D形状生成](https://arxiv.org/abs/2502.06608)（論文）。3D形状の生成と品質評価

[評価と比較](../skills/adjudicate/SKILL.md)

### 任意のトポロジーを持つ形状

[SparseFlex（TripoSF）・任意のトポロジーを持つ3D形状](https://arxiv.org/abs/2503.21732)（論文）。任意のトポロジーを持つ形状の表現

[評価と比較](../skills/adjudicate/SKILL.md)

### 密度を制御する三次元生成

[TripoSplat・密度を制御する3Dガウシアン生成](https://arxiv.org/abs/2605.16355)（論文）。密度を制御する3Dガウシアン生成

[評価と比較](../skills/adjudicate/SKILL.md)

### 動かせる三次元アセット

[AniGen・アニメーション可能な3Dアセット生成](https://arxiv.org/abs/2604.08746)（論文）。アニメーション可能な3Dアセット生成

[評価と比較](../skills/adjudicate/SKILL.md)

### 頂点とトポロジーを扱うメッシュ生成

[Nexus・頂点とトポロジーを扱うメッシュ生成](https://doi.org/10.1145/3811344)（論文）。頂点とトポロジーを扱うメッシュ生成

[評価と比較](../skills/adjudicate/SKILL.md)
