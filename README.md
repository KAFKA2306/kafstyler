---
type: guide
description: "常時稼働エージェントのためのKafstyler。大規模運用、引き継ぎ、実装、検証、改善を扱う7 Skills。"
---

# Kafstyler

**AIエージェントが常時稼働し、成果を積み上げる。**

Kafstylerは、Claude Code・Codex・Antigravity CLIで使う7つのSkillsです。**autocatalyze** が常時稼働の制御を担い、**reconceptualize・canonicalize・disprove・adjudicate・didactization・decommission** が判断、正本、品質、知見、整理を受け持ちます。複数のAI担当・セッション・プロジェクトをまたいで、**観測、案件選定、実行、検証、復旧、引き継ぎ、次の起動**をつなぎます。一件のタスクが完了しても、全体の運用は続きます。

[できること](#kafstylerが変えること) · [まず一件試す](#まず一件試す) · [導入する](#プラグインの使い方) · [常時稼働の仕組み](#常時稼働エージェントの中核) · [実例を見る](#成果から使い方を選ぶ)

## Kafstylerが変えること

| 運用中の課題 | Kafstylerの仕組み |
| --- | --- |
| 案件が増えると、担当AIに毎回説明し直す | `canonicalize` が正本と状態をそろえ、`autocatalyze` が前回の記録から再開する |
| 定期実行が成功したように見えて、成果が届かない | `adjudicate` で利用者の入口の結果を確かめ、`autocatalyze` が失敗を次の実行へ引き継ぐ |
| AIやセッションの交代で、途中工程が重複・消失する | 作業ID、対象版、確認済みの結果、未処理、次の起動条件を引き継ぐ |
| 案件が増えるほど旧処理・重複検証・通知が残り、開発より維持管理に時間を使う | `decommission` が旧経路を安全に廃止し、実行回数・費用・障害の原因を減らして次の改善に余力を戻す |

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

例として、**公表統計の検索画面とCSVを毎週更新し、過去の数値が訂正されたときも正しく追従する運用**を考えます。定期更新を一度成功させるだけでなく、データの改定、公開先の不一致、担当AIの交代をまたいで成果の品質を維持する仕事です。

### 7つのSkillが連関して成果を出す

| Skillが行うこと | 次へ渡す具体的な結果 |
| --- | --- |
| [`autocatalyze`](skills/autocatalyze/SKILL.md) は週次起動で前回の状態を復元し、統計の新しい公表・訂正を調べて、更新すべき系列と期間を選ぶ。 | 対象系列ID・対象月・入力の版・最後の成功・未処理事項を `reconceptualize` と `canonicalize` へ渡す |
| [`reconceptualize`](skills/reconceptualize/SKILL.md) は「ファイルを生成する」ではなく「公開画面とCSVで同じ訂正値・単位・出典を確認できる」を目的にする。 | 利用者の操作、代表入力、合格条件を `canonicalize` と `adjudicate` へ渡す |
| [`canonicalize`](skills/canonicalize/SKILL.md) は発行元・系列ID・対象期間・公表日で初報と改定値を区別し、画面とCSVが使う正本をそろえる。 | 正本の場所、識別子、訂正履歴、再処理範囲を `disprove` と `autocatalyze` へ渡す |
| [`disprove`](skills/disprove/SKILL.md) は初報と改定値の混同、重複取り込み、取得失敗時の古い数値の誤表示など、結果を壊す反例を探す。 | 再現できる失敗条件と修正対象を `autocatalyze`、判定用の入力を `adjudicate` へ渡す |
| [`autocatalyze`](skills/autocatalyze/SKILL.md) は必要な取得・集計・画面更新を実装して公開し、公開先の版を読み戻す。 | 実際の画面・CSV・実行ログを `adjudicate` へ渡す |
| [`adjudicate`](skills/adjudicate/SKILL.md) は原典・画面・CSVの系列、値、件数、出典を同条件で照合し、再取り込みでも二重登録しないか確かめる。 | 合否・実測値・再現手順を `autocatalyze` に返し、不合格なら修正へ戻す |
| [`didactization`](skills/didactization/SKILL.md) は今回の訂正処理や失敗から、次の系列・別プロジェクトでも使える原則と再現例を残す。 | 出典と成立条件のある知見を既存の正本へ渡す |
| [`decommission`](skills/decommission/SKILL.md) は `canonicalize` の正本と `adjudicate` の比較結果を受けて、二重同期・古い集計・重複通知を安全に廃止する。 | 必要な機能が維持された証拠、減らした起動・管理負荷、唯一の現行経路を `canonicalize` と `autocatalyze` に返す |
| [`canonicalize`](skills/canonicalize/SKILL.md) は最終確認した版、処理済み位置、未処理、次の起動条件を既存記録にそろえる。 | 別の担当AIや次回の `autocatalyze` が会話の再説明なしで使える状態を残す |

```mermaid
flowchart TD
    trigger["週次起動・新しい公表・障害・再開"] --> auto["autocatalyze：状態復元と案件選定"]
    auto --> goal["reconceptualize：公開画面とCSVの合格条件を定める"]
    goal --> canon["canonicalize：系列ID・公表日・正本を統一"]
    canon --> proof["disprove：初報と改定値の混同などを反証"]
    proof --> build["autocatalyze：取得・集計・画面を更新して公開"]
    build --> judge["adjudicate：原典・画面・CSVを同条件で照合"]
    judge --> decision{"実物の結果は合格？"}
    decision -->|不合格| build
    decision -->|合格| learn["didactization：失敗と訂正を再利用できる知見に"]
    learn --> retire["decommission：旧経路・重複通知・不要な検査を廃止"]
    retire --> freed["decommission：管理負荷・二重実行の削減を確認"]
    freed --> record["canonicalize：現行経路・版・結果・再開条件を記録"]
    record --> next["次の定期起動・別担当AIへの引き継ぎ"]
    next --> auto
```

この図は7 Skillsの連携が役立つケースを示したものです。毎回7つ全部を呼ぶ仕組みではありません。たとえば新規データに訂正も障害もなければ、`autocatalyze` は差分を確認して不要な再処理を省きます。**一件の成功は次の周期の入力となり、運用と改善は継続します。**

[画面の設計正本](https://github.com/KAFKA2306/design) · [定期実行と再開](skills/autocatalyze/SKILL.md#常駐エージェントと定期実行)

## decommissionが常時稼働の実行力を守る

**[`decommission`](skills/decommission/SKILL.md) は、長期間の自律運用で増え続ける維持管理の負担を取り除き、`autocatalyze` が新しい成果に使える余力を生み出すSkillです。** 単なるファイル削除ではありません。使われなくなった経路、同じ仕事を繰り返す定期処理、重複する正本、効果のない検査や通知を、必要な機能を維持したまま廃止します。

例えば統計データの更新方式を切り替えた後、旧ジョブが残ると同じデータを二度取得し、古いCSVを再公開し、通知まで重複する恐れがあります。`canonicalize` が残す正本を決め、`adjudicate` が新方式の結果を検証し、`decommission` が旧ジョブ・設定・参照を停止・削除します。`autocatalyze` は次回の通常起動で新方式だけが動くことを確かめ、浮いた実行枠を次の案件へ使えます。

`decommission` の成果は削除ファイル数ではなく、**必要な機能を保ちながら減らせた処理回数・実行時間・費用・誤通知・保守対象**で測ります。比較できる実績がない場合は削減効果を推定値として区別します。不要と証明できないものは件数目標のために消しません。

## 成果から使い方を選ぶ

分野が変わっても、`autocatalyze` が案件を選び、必要なSkillが結果を返し、その成果を次の観測へ引き継ぎます。「イベント収集を直して」なら、[公開カレンダー](https://github.com/KAFKA2306/cast_event_cal)のURLと「開催回が公開WebとICSに一度ずつ載り、主催者の告知を開ける」という合格条件を渡します。目的と結果は[作業台帳](AGENTS.md#正本と記録)に残ります。

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
