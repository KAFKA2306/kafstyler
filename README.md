---
type: guide
description: "常時稼働エージェントのためのKafstyler。大規模運用、引き継ぎ、実装、検証、改善を扱う7 Skills。"
---

# Kafstyler

**AIエージェントが常時稼働し、成果を積み上げる。**

Kafstylerは、Claude Code・Codex・Antigravity CLIで使う7つのSkillsです。複数のAI担当・セッション・プロジェクトをまたぐ長期運用を前提に、**観測、案件選定、実行、検証、復旧、引き継ぎ、次の起動**をつなぎます。一件のタスクが完了しても、全体の運用は続きます。

[できること](#kafstylerが変えること) · [まず一件試す](#まず一件試す) · [導入する](#プラグインの使い方) · [常時稼働の仕組み](#常時稼働エージェントの中核) · [実例を見る](#成果から使い方を選ぶ)

## Kafstylerが変えること

| 運用中の課題 | Kafstylerの仕組み |
| --- | --- |
| 案件が増えると、担当AIに毎回説明し直す | `canonicalize` が正本と状態をそろえ、`autocatalyze` が前回の記録から再開する |
| 定期実行が成功したように見えて、成果が届かない | `adjudicate` で利用者の入口の結果を確かめ、`autocatalyze` が失敗を次の実行へ引き継ぐ |
| AIやセッションの交代で、途中工程が重複・消失する | 作業ID、対象版、確認済みの結果、未処理、次の起動条件を引き継ぐ |
| 手順・監査・テストばかり増えて運用が重くなる | `decommission` で余分な仕組みを廃止し、必要なSkillsだけ動かす |

[改善の事例](https://github.com/KAFKA2306/articles/blob/main/articles/kafstyler-agent-quality-loop.md) · [継続的なデータ運用例](https://github.com/KAFKA2306/semiconductor-earnings-model)

## まず一件試す

公開リポジトリを題材に、現状確認から一件の改善と次回への引き継ぎを試せます。対象URLは自分のプロジェクトに置き換えられます。

```text
対象: https://github.com/KAFKA2306/semiconductor-earnings-model

Kafstylerのautocatalyzeを使い、既存のIssueと実際の公開成果を調べ、
いま最も価値のある改善を一件選び、実装・検証・反映まで進めてください。
必要なSkillsだけを使い、次回は別のAI担当でも再開できるよう
作業ID、対象版、判断根拠、検証結果、未処理と次の起動条件を既存の記録に残してください。
```

継続運用は既存の定時・イベント起動と組み合わせます。詳しくは [autocatalyze](skills/autocatalyze/SKILL.md#常駐エージェントと定期実行) を参照してください。

## プラグインの使い方

[Claude Code](#claude-code) · [Codex](#codex) · [Antigravity CLI](#antigravity-cli)

### Claude Code

```sh
claude plugin install kafstyler --marketplace KAFKA2306/agent-resources --scope user
```

[配布元](https://github.com/KAFKA2306/agent-resources/blob/main/.claude-plugin/marketplace.json)。対象プロジェクトで `claude` を起動します。

### Codex

```sh
codex plugin marketplace add KAFKA2306/kafstyler
codex plugin add kafstyler@kafstyler
```

対象プロジェクトで `codex` を起動します。

### Antigravity CLI

```sh
agy plugin install https://github.com/KAFKA2306/kafstyler
agy plugin list --json
```

対象プロジェクトで `agy` を起動します。

### 依頼を送って使う

必要なSkillを直接指定する場合は、Claude Codeで `/kafstyler:autocatalyze`、Codexで `$autocatalyze`、Antigravity CLIで `/autocatalyze` を使います。たとえばデータ移行では `canonicalize`、旧方式の整理では `decommission` を選べます。

### プラグインの更新と検証

- Claude Code: `claude plugin update kafstyler@kafka-agent-tools`。新しいセッションまたは `/reload-plugins` で変更を反映します。
- Codex: `codex plugin marketplace upgrade kafstyler` と `codex plugin add kafstyler@kafstyler`。新しいセッションで読み込みを確認します。
- Antigravity CLI: `agy plugin list --json` で導入版とSkillsの検出を確認します。

### 作業中の版で試す

Claude Codeは `claude plugin validate .`、Antigravity CLIは `agy plugin validate --json .` など、各CLIの標準の検証を使います。変更したSkillが読み込まれることと、該当する実際の依頼の結果を確認します。スキル呼び出しのためのフック承認・全Markdown監査は不要です。

## 常時稼働エージェントの中核

[`autocatalyze`](skills/autocatalyze/SKILL.md#常時稼働エージェントの中核) は、**常時稼働エージェントの中核Skill**です。定時・イベント・再開を入口として、進行中の案件だけでなく、次の改善候補や新しい障害を観測し続けます。必要なときに他のSkillsへ委譲し、実装、公開先の検証、復旧、成果の蓄積を統括します。

長期運用では、一件の「完了」は次の観測へ進むための通過点です。仕事がない周期には不要なLLM呼び出しや通知をせず、次の起動を維持します。起動には接続済みのスケジューラーやイベント機構を使い、Kafstyler自体が独立した常駐サービスを提供するわけではありません。

## 大規模な開発を支える仕組み

[`canonicalize`](skills/canonicalize/SKILL.md) は複数の担当が共有する正本、識別子、入力・出力、版、訂正履歴をそろえます。[`autocatalyze`](skills/autocatalyze/SKILL.md) はその情報から作業を復元し、公開・更新・障害復旧を続けます。

たとえば公表統計の検索画面とCSVを毎週更新するなら、収集担当、データ担当、画面担当が同じ正本を使います。

1. 発行元・系列ID・対象期間で統計値を識別し、単位と公表日、出典を保持する。
2. 同じ正本から画面とCSVを更新し、公開先の内容を原資料と照合する。
3. 数値の改定や障害を検知したら該当期間を再処理し、反映済みと未反映を区別する。
4. 作業状態と検証結果を保存し、別セッション・別担当・次回起動へ渡す。

[画面の設計正本](https://github.com/KAFKA2306/design) · [定期実行と再開](skills/autocatalyze/SKILL.md#常駐エージェントと定期実行)

### 7つのスキルと、残す成果物

```mermaid
flowchart TD
    event["定時・イベント・新しい課題・中断後の再開"] --> run["autocatalyze：復元・観測・案件選定・実行"]
    run -.->|目的・合格条件| goal["reconceptualize：目的を定義"]
    run -.->|正本・状態| canon["canonicalize：正本と引き継ぎを設計"]
    run -.->|成果・方式の評価| judge["adjudicate：実物を評価"]
    run -.->|前提の反証| proof["disprove：反例を調べる"]
    run -.->|知見と文章| edit["didactization：教材化・推敲"]
    run -.->|旧方式の整理| retire["decommission：不要なものを廃止"]
    run --> actual["実装・公開・利用結果を確認"]
    actual --> state["既存の正本に版・根拠・実績・未処理・再開条件を記録"]
    state --> handoff["別担当・別セッションへ引き継ぎ、次の周期に備える"]
    handoff --> event
```

実線は繰り返す運用、点線は必要な場合に選ぶSkillです。すべてのSkillsを毎回実行するわけではありません。成果が積み上がるほど、既存の正本と実績を次の改善に再利用できます。

| Skill | 担当する判断と残す成果 |
| --- | --- |
| [`autocatalyze`](skills/autocatalyze/SKILL.md) | 起動・観測・案件選定・委譲・実装・検証・復旧・引き継ぎを継続する |
| [`reconceptualize`](skills/reconceptualize/SKILL.md) | 利用者の目的と、実際の入口で測れる結果を定める |
| [`canonicalize`](skills/canonicalize/SKILL.md) | 正本・識別子・版・履歴・再開に必要な状態をそろえる |
| [`adjudicate`](skills/adjudicate/SKILL.md) | 同じ入力・評価条件で成果を測り、採否と証拠を返す |
| [`disprove`](skills/disprove/SKILL.md) | 前提の反例、重大な欠陥、代替方式を調べる |
| [`didactization`](skills/didactization/SKILL.md) | 発見を再利用可能な知見にし、文章の原意を守って推敲する |
| [`decommission`](skills/decommission/SKILL.md) | 重複したコード・文書・処理を統合し、旧方式を廃止する |

## 成果から使い方を選ぶ

「イベント収集を直して」なら、[公開カレンダー](https://github.com/KAFKA2306/cast_event_cal)のURLと「開催回が公開WebとICSに一度ずつ載り、主催者の告知を開ける」という合格条件を渡します。目的と結果は[作業台帳](AGENTS.md#正本と記録)に残ります。

### 開発・運用

停止した処理を最終成功時刻と失敗ログから直し、次の結果を利用者のURLで確認する。画面は初見で情報と出典を探し、迷った操作と合格条件を一件にまとめる。[定期運用](https://github.com/KAFKA2306/agent-resources) · [画面の評価例](https://github.com/KAFKA2306/design/blob/main/docs/frontend-review.md)

### 記事・動画・音声

記事は実際の発見から再利用できる原則を抽出し、数値や実験を一次資料・再実行で確かめ、成立しない条件を示す。発見がないときは既存記事を改善し、新規公開や重複を増やさない。動画は音声・字幕を通しで確認し、公開先でチャンネル・公開状態を確かめる。音声は同じ台詞で比較し、採用WAV・モデル・シード・参照音声を残す。[記事](https://github.com/KAFKA2306/articles/blob/main/articles/kafstyler-agent-quality-loop.md) · [動画](https://github.com/KAFKA2306/yt3) · [音声](https://github.com/KAFKA2306/yt4)

### VRChat・3D・画像制作

ワールドでは初期位置から展示へ歩き、案内を読んで操作する。衣装はUnityで取り込み・装着し、指定ポーズで貫通とウェイト崩れを確認する。画像は素材・シード・サイズをそろえ、画質と処理時間を比べる。[VRMine](https://github.com/KAFKA2306/vrmine) · [衣装](https://github.com/KAFKA2306/image2outfit) · [ComfyUIの制作台帳](https://github.com/KAFKA2306/comfyui-workflows-factory)

### ボードゲーム・ゲーム

スマホで作品と版を選び、プレイ中に裁定と公式説明書の該当ページを開く。MODはSteam版に導入し、プレイ中に効果を確かめる。[ボドゲのミカタ](https://bodoge-no-mikata.vercel.app/) · [Slay the Spire 2のMOD](https://github.com/KAFKA2306/sts2)

### 企業・市場の調査

半導体の価格と出荷は決算期・単位をそろえ、実績・会社予想・シナリオを分けて、公開画面で式と一次開示を開く。統計は初報・改定値を対象月・公表日で区別し、公開CSVを原資料と照合する。[半導体決算モデル](https://github.com/KAFKA2306/semiconductor-earnings-model) · [米雇用統計](https://github.com/KAFKA2306/nonfarmpayroll)

### 科学・製造の調査

同じ材料・加工目的の候補を一次資料から探し、温度・圧力・速度などの条件と歩留まり・欠陥率を表にする。論文は対象・比較条件・測定値と引用箇所を記録し、案件で試せる条件を選ぶ。[製造工程の調査](https://github.com/KAFKA2306/factory) · [arXiv調査](https://github.com/KAFKA2306/daily-arXiv-ai-enhanced)

### Kaggle

データ版・時系列分割・公式指標・ベースラインをそろえ、手元の検証と公式提出の結果を分けて記録する。[商品価格予測コンペ](https://github.com/KAFKA2306/mitsuikaggle)

### 暮らしと学習

家計は明細の再取り込みで件数・合計が変わらず、差額から元の取引を開けるか試す。蔵書は同じ作品の別版を区別し、目的のノートに戻る。旅行は公式時刻・総額・取消条件を比べ、現地時刻で乗り換えを確かめる。[家計](https://github.com/KAFKA2306/kakeibo) · [蔵書](https://github.com/KAFKA2306/books) · [旅行計画](https://github.com/KAFKA2306/travel)

## スキル

Claude Codeは `/kafstyler:<名前>`、Codexは `$<名前>`、Antigravity CLIは `/<名前>` からSkillを選びます。各Skillの目的と判断基準は[7つのスキルと、残す成果物](#7つのスキルと残す成果物)を参照してください。

端末を閉じた後の定期実行やイベント起動は、[autocatalyzeの実行方法](skills/autocatalyze/SKILL.md#常駐エージェントと定期実行)を使います。実行前に必要な権限と接続、前回の状態を確認します。

## Unity・VRChatで制作する

汎用Unityは `CoplayDev/unity-mcp`、VRChat Worldsは `swax/UnityMCP-VRC`、VRChat Avatarsは `lighfu/unity-agent` を使い、Unity EditorやVRChat SDKで成果を確かめます。[公式の接続手順](BIBLES.md#ユニティとvrchatの制作ツール)

## 外部スキルとテンプレート

### 成果物の根拠調査と推敲

imozuruで根拠を原文までたどり、yomiyasuで説明を整え、反証レビューで利用場面に照らします。Claude CodeかCodexの新しいセッションで両方を選べることを確かめます。[成果物の確認手順](skills/didactization/SKILL.md#本文の推敲と提出前の確認)

```sh
npx skills add MaryCache/imozuru
npx skills add nanaism/yomiyasu
```

### Googleのフロントエンド設計スキル

KAFKA2306のWeb UIを設計するときは[かふかのデザインパターン](BIBLES.md#かふかのデザインパターン)を先に確認します。Claude Codeで `/plugin marketplace add google-gemini/demolab`、`/plugin install demolab@demolab` の順に実行し、`/demolab:gemini-frontend-design` で設計案を検討します。[Google Gemini DemoLabの導入手順](https://github.com/google-gemini/demolab#claude-code)

### ComfyUIのワークフローテンプレート

[採用基準](BIBLES.md#comfyuiのワークフロー選定)に合わせ、`Workflow → Browse Workflow Templates` で候補を開き、必要なモデルと出力を確認します。[ComfyUI公式手順](https://docs.comfy.org/interface/features/template) · [テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)

## ミッション・聖典・作業規約

[ミッション](MISSION.md) · [一次資料の聖典台帳](BIBLES.md) · [共通作業規約](AGENTS.md) · [目次](index.md)

過去の知見を次の仕事へつなぐために、引き継ぐ判断・版・根拠は既存の正本に残します。案件固有の実装と履歴は案件のリポジトリで管理します。
