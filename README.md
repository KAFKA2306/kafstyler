---
type: "guide"
description: "Kafstylerの目的、導入方法、スキルと外部ツールの使い方。"
tags:
  - kafstyler/guide
  - kafstyler/plugin
aliases:
  - "使い方"
---

# Kafstyler

Kafstylerは、Claude Code、Codex、Antigravity CLIのAIエージェントが、開発・調査・制作・運用で何をもって完了とするかを決め、成果物を検証して届けるためのプラグインです。文章の推敲やデータ設計など、作業に応じてスキルを組み合わせます。複数の仕事に共通する手順の漏れが見つかれば、再現してKafstyler自体を直します。

[成果から使い方を選ぶ](#成果から使い方を選ぶ)では、活動ごとに、何を作り、どこで確かめるかを指定する依頼例を紹介します。

## プラグインの使い方

### Claude Code

Claude Code 2.1.292以降で、ターミナルから次のコマンドを実行します。WindowsではWSLかGit Bashを使います。[配布元](https://github.com/KAFKA2306/agent-resources/blob/main/.claude-plugin/marketplace.json)

```sh
claude plugin install kafstyler --marketplace KAFKA2306/agent-resources --scope user
```

対象プロジェクトで `claude` を起動します。

### Codex

ターミナルで配布元を追加し、プラグインを導入します。WindowsではWSLで実行します。

```sh
codex plugin marketplace add KAFKA2306/kafstyler
codex plugin add kafstyler@kafstyler
```

対象プロジェクトで `codex` を起動し、`/hooks` でKafstylerのフックを確認・承認します。承認前もスキルは手動で選べます。更新後に再確認が表示されたら同じ操作を行います。[Codexのフック承認](https://learn.chatgpt.com/docs/hooks#review-and-trust-hooks)

### Antigravity CLI

使う端末に[Googleの公式手順](https://antigravity.google/docs/getting-started?tab=cli)で `agy` を導入します。WindowsとWSLの両方で使う場合は、それぞれのシェルで実行ファイルと `agy --version` を確認します。

WindowsのPowerShellでは次を実行します。既定の導入先は `%LOCALAPPDATA%\agy\bin` です。

```powershell
Get-Command agy -All
agy --version
```

WSLのBashでは次を実行します。Linuxの既定の実行ファイルは `~/.local/bin/agy` です。ユーザー単位で導入した場合は、実行ユーザーが導入先を所有し、書き込めることを確認します。

```bash
type -a agy
agy --version
id -un
agy_bin=$(type -P agy) && agy_bin=$(realpath -- "$agy_bin") &&
  stat -Lc '%U %A %n' -- "$agy_bin" "$(dirname -- "$agy_bin")" &&
  test -w "$(dirname -- "$agy_bin")" && echo '導入先に書き込み可能'
```

使うシェルで配布版を導入します。一覧に `kafstyler` が有効と表示され、7スキルが登録されたことを確かめます。対象プロジェクトで `agy` を起動すると `/charter` や `/deliver` からスキルを呼べます。

```sh
agy plugin install https://github.com/KAFKA2306/kafstyler
agy plugin list --json
```

モデルを指定したヘッドレスのレビューは[自律開発の手順](skills/deliver/SKILL.md#antigravity-cliでレビューする)を、仕様は[聖典台帳](BIBLES.md#antigravity-cliの配布と実行)を参照します。

### 依頼を送って使う

「READMEを初めて読む人が、手順どおりに起動できるように整えて」のように依頼します。

プラグインは、各スキルの発動条件をエージェントへ渡します。スキル名を書かなくても、作業の段階ごとに該当するスキルを使うよう指示します。たとえば「台帳の列を統一し、移行後に旧ファイルを整理して」では、設計前に `schema`、移行後の削除前に `prune` を使います。委譲先にも同じ発動条件と[作業規約](AGENTS.md#コマンドの連携)を渡します。

エージェントがコミットするときは、毎回、記録する差分と検証結果を照合し、作成後にSHAと差分を確認します。コミットだけを頼んだ場合にも適用します。[コミットの手順](AGENTS.md#ブランチとコミット)

1. 普段の入口、成功と分かる結果、改善の比較基準を決めます。
2. 文書では、見出しから必要な手順を見つけ、記載どおりに操作できるかを確かめます。コードやデータでは、現物を同じ入力と合格条件で評価します。
3. エージェントは提出前に成果物とスキルの実行結果を確認します。欠陥を直したら同じ条件で再評価します。[評価と自己改善の手順](skills/charter/SKILL.md#成果物の確認と手順の改善)

### プラグインの更新と検証

- Claude Codeでは `claude plugin update kafstyler@kafka-agent-tools` で更新し、新しいセッションを開始するか `/reload-plugins` を実行します。今後の改善版を自動取得するには、`/plugin` の Marketplaces で `kafka-agent-tools` の自動更新を有効にします。[Anthropicの更新手順](https://code.claude.com/docs/en/discover-plugins#keep-plugins-updated)
- Codexでは `codex plugin marketplace upgrade kafstyler` で配布元を更新し、`codex plugin add kafstyler@kafstyler` を実行して新しいセッションを開始します。[Codexのプラグインコマンド](https://learn.chatgpt.com/docs/developer-commands#codex-plugin)

同じ配布元を `marketplace add` で再登録すると、以前の版が残ることがあります。評価や不具合調査の前は、`codex plugin list` に表示される版と対象コミットのマニフェストを照合します。食い違う場合は配布元を更新してから検証します。

### 作業中の版で試す

Kafstyler本体の作業を始める前に、リポジトリのルートで `base=$(git rev-parse main)` を実行し、着手前のコミットを記録します。変更後は同じルートで、着手前の検査と候補版の検査をどちらも候補版にかけます。

```bash
(set -o pipefail; git show "${base}:hooks/check.py" | python3 -)
python3 hooks/check.py
```

検査は両プラグインの設定からフックを実行します。起動時に規約が渡り、依頼受付時に配布スキルの発動条件が渡ることを確かめます。

本体の全Markdownに全スキルを使い、文書ごとの結果を [適用記録](hooks/markdown-reviews.json) に残します。検証で記録の不足や古い版を検出します。変更をステージしたら、`python3 hooks/check.py --staged` でコミットする版を確かめます。[適用と記録の手順](AGENTS.md#全markdownに全スキルを使う)

- Claude Codeでは `claude plugin validate .` を実行し、`claude --plugin-dir "$PWD"` で作業中の版を起動します。別プロジェクトで試すときも、`--plugin-dir` にKafstylerのチェックアウトの絶対パスを渡します。
- Codexでは検証用の `CODEX_HOME` を用意し、`codex plugin marketplace add "$PWD"` と `codex plugin add kafstyler@kafstyler` を実行します。プラグインは導入時点のコピーを使います。変更後に試し直す場合は、検証用の環境で `codex plugin remove kafstyler@kafstyler` を実行してから再導入します。新しいセッションの `/hooks` で検証する版のフックを確認・承認します。[ローカル配布元の仕様](https://developers.openai.com/plugins/build/plugins#how-local-marketplaces-work)
- Antigravity CLIでは `agy plugin validate --json .` で候補版を検査します。検証環境で `agy plugin install .` と `agy plugin list --json` を実行し、候補の版、7スキル、常時有効なルールを確認します。マルチツール構成に関する既知の警告は[公式の判定手順](https://antigravity.google/docs/build-plugins/#warnings-in-multi-tool-repositories)で見分けます。

変更が影響するクライアントでスキル名を含まない依頼を送り、スキルを使った時点を呼び出し履歴や `SKILL.md` の読み込みから確認します。手順の実行結果と成果物も照合します。提出前に漏れが見つかった場合は、該当する手順を実行し、その結果が影響する工程をやり直したことまで確かめます。[本体の変更手順](AGENTS.md#kafstyler本体の変更)

## 成果から使い方を選ぶ

たとえば「イベント収集を直して」と頼むときは、「同じ開催回が公開カレンダーとICSに一度ずつ載り、参加者が主催者の告知を開けるように」と、使う人が確かめられる結果まで渡します。下の依頼文は、対象のファイル、URL、入力を添えて使えます。Kafstylerは着手時に目的と完了条件を記録し、提出前に成果と検証結果を追記します。[作業台帳](AGENTS.md#作業台帳)

2026年11月17日に、KAFKA2306所有の公開・非アーカイブのリポジトリから、10月19日〜11月17日にプッシュがあった70件を集計しました。READMEや公開物から主な用途を確かめ、1リポジトリを1分野に数えました。[GitHubの集計条件](https://github.com/search?q=user%3AKAFKA2306+is%3Apublic+archived%3Afalse+pushed%3A2026-10-19..2026-11-17&type=repositories)

| 分野 | 公開リポジトリ |
| --- | ---: |
| [開発・運用](#開発運用) | 7 |
| [記事・動画・音声](#記事動画音声) | 7 |
| [VRChat・3D・画像制作](#vrchat3d画像制作) | 15 |
| [ボードゲーム・ゲーム](#ボードゲームゲーム) | 7 |
| [企業・市場の調査](#企業市場の調査) | 14 |
| [科学・製造の調査](#科学製造の調査) | 12 |
| [Kaggle](#kaggle) | 1 |
| [暮らしと学習](#暮らしと学習) | 7 |

### 開発・運用

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 止まった定期処理が復旧し、利用者に最新の結果が届く。[運用画面](https://github.com/KAFKA2306/agent-resources) | 止まった処理を一つ選び、最後の成功時刻と失敗ログを照合して直して。通常の実行または次の定時実行で生成された成果を、利用者が見るURLから開いて。 |
| 初めて使う人が、欲しい情報を見つけて判断できる。[画面評価と修正指示の例](https://github.com/KAFKA2306/design/blob/main/docs/frontend-review.md) | このURLから、初めて来た人として会社の直近の実績を調べて。得られた数値と出典、途中で足りなかった情報を示して。直す場所と、同じ調べ方で何が分かれば合格かを一件にまとめて。 |
| 旧設定を整理した後も、別環境で同じ成果を再生成できる。[モデルの共有キャッシュ](https://github.com/KAFKA2306/hf-cache-hub) | 使うモデルの版と配布物のハッシュを固定して。空のキャッシュから取得・生成を再現し、参照先の切り替えを確かめてから旧設定を消して。 |
| 再利用した依頼から、必要な入力と成果物の版をたどれる。[Prompt Vault](https://github.com/KAFKA2306/prompt-vault) | 依頼文、入力例、生成物を結び、別のセッションで一件を再実行して。同じ目的の古い手順を参照している箇所も調べて。 |
| 次の仕事で同じ手順漏れが起きない。[Kafstylerの改善手順](MISSION.md#更新手順) | 漏れが起きた依頼と期待した結果を記録して。手順を一か所直し、元の依頼と別分野の依頼で同じ漏れが防げるか試して。 |

### 記事・動画・音声

[Zennのプロフィール](https://zenn.dev/kafka2306)に25記事、[はてなブログの2026年1月](https://kafkafinancialgroup.hatenablog.com/archive/2026/01)と[2月](https://kafkafinancialgroup.hatenablog.com/archive/2026/02)の一覧に計7記事がありました。[YT3](https://github.com/KAFKA2306/yt3#release-and-publication)では動画制作の設定を3チャンネル分確認しました。

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 記事を読んだ人が、自分の案件でも同じ判断や操作ができる。[記事の公開原稿](https://github.com/KAFKA2306/articles/blob/main/articles/kafstyler-agent-quality-loop.md) | 読者が最初に困る操作を冒頭に置いて。タイトルと見出しだけで答えの場所が分かり、本文の手順をたどると同じ結果になるか試して。引用、数値、図も原典と照合して。 |
| 意図した原稿が公開候補に出る。[実際に修正したPR](https://github.com/KAFKA2306/articles/pull/228) | 同じ記事IDで中身が違う原稿を二つ用意して、手動実行で指定した方が公開候補に表示されることを確認して。 |
| 字幕と音声がそろった動画を、指定したチャンネルで確認できる。[秒算マネー](https://www.youtube.com/@byosan-money)・[動画制作の手順](https://github.com/KAFKA2306/yt3) | 台本の数値を一次資料に照合し、音声・字幕・映像を通しで確認して。許可された公開範囲まで進めたら、動画URLを開いてチャンネル名と公開状態を確かめて。 |
| 同じ文章で聴き比べられる音声候補と、再生成できる設定がそろう。[yt4](https://github.com/KAFKA2306/yt4) | 同じ台詞から音声を作り、モデル・シード・参照音声を記録して。F0中央値、サ行の刺激、読み落としを同じ条件で比べ、採用したWAVと設定を残して。 |
| 音声解説から引用元の資料に戻れる。[探究室とNotebookLM](https://github.com/KAFKA2306/nlm) | 入力資料を固定して音声解説を作り、主要な主張と数値を原文の該当箇所に照合して。資料一覧と音声を一緒に開ける形で渡して。 |

### VRChat・3D・画像制作

Studio Kafkaの配布物は[MeshSyncPro](https://booth.pm/ja/items/6905506)と[BoneSync Pro](https://booth.pm/ja/items/6893042)の個別ページ2点を確認しました。[VRChatイベントカレンダー](https://github.com/KAFKA2306/cast_event_cal/blob/dec489d318a2acbdd17887c834e04d76830e7612/public/snapshot.json)の11月17日22時17分（日本時間）の記録には922開催回が掲載されています。

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 初参加者がワールドに入り、目的の展示やギミックを使える。[VRMine](https://github.com/KAFKA2306/vrmine) | 初期位置から展示まで歩き、操作の案内を読んでギミックを使えるか確認して。入室直後と入り直した後の見え方も比べて。 |
| 衣装をUnityに導入でき、指定ポーズで破綻しない。[image2outfit](https://github.com/KAFKA2306/image2outfit) | 配布するPrefabを指定して、Unityで取り込みから装着まで通して。正面・背面・屈曲など指定した方向と姿勢で、貫通とウェイト崩れをレンダーに残して。 |
| 写真から生成した3D素材が、展示シーンで読める。[写真からの3D復元](https://github.com/KAFKA2306/AutoPhotogrammetry)・[VRChat向け表示](https://github.com/KAFKA2306/VRChatGaussianSplatting) | 同じ写真組で二つの方式を試して。欠け、サイズ、表示負荷を見比べ、採用した素材をUnityシーンで確認して。 |
| 画像や映像を同じ条件で作り直せる。[ComfyUIの制作台帳](https://github.com/KAFKA2306/comfyui-workflows-factory) | 同じ素材・シード・出力サイズで候補を動かし、画質、処理時間、最大VRAMを比べて。採用したWorkflowとモデルの版を残し、再実行して。 |
| 対応アバターと導入条件が購入前に分かり、配布ZIPから導入できる。[BOOTH商品データ](https://github.com/KAFKA2306/boothitemmanager) | 商品説明の対応アバターと利用条件を配布物に照合して。空のUnityプロジェクトに同梱手順だけで導入し、商品ページの表記を確かめて。 |
| 開催回が重複せず、主催者の告知から日時と参加方法を確認できる。[イベントカレンダー](https://github.com/KAFKA2306/cast_event_cal) | イベント一件を選び、主催者の告知と公開Web・ICSの日時、タイムゾーン、参加リンクを突き合わせて。同じ開催回が各形式で一件だけになることを確認して。 |
| 活動記を読み返せて、公開ページには公開指定した記録が載る。[VLog](https://github.com/KAFKA2306/vlog)・[VRChat活動記](https://note.com/kafkavr) | 写真と出来事を時刻と出典付きで整理して。公開可否を指定した入力で、公開Readerに載る記事と下書きの扱いを確認して。 |

### ボードゲーム・ゲーム

[ゲーム管理データ](https://github.com/KAFKA2306/game-library-dashboard/blob/405608700d4699b6ae279b9e871a4587e442f3b6/data/game-library.json)の2026年8月9日版で55レコード、[noteの公開一覧](https://note.com/kafkavr)でJoinWarsの大会・予選レポートを5本確認しました。

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 手元の版に合う裁定を、遊んでいる途中に確認できる。[ボドゲのミカタ](https://bodoge-no-mikata.vercel.app/) | 『ブラス：バーミンガム』の運河時代終了時の得点を、版ごとの公式説明書と照合して。スマホで作品と版を選び、得点処理と説明書の該当ページを開いて。 |
| 対戦の転機と、次回に試す手が分かる。[JoinWarsの大会記録](https://note.com/kafkavr) | 対戦ログから転機の手番を一つ選び、その時点で選べた別の手と結果の違いを示して。同じ盤面を再現できるように手順と前提を残して。 |
| 配布したMODがSteam版で動き、プレイヤーが効果を確認できる。[Slay the Spire 2のMOD](https://github.com/KAFKA2306/sts2) | 配布物を手順どおり導入して。毎ターン3枚目のカードの種類で人形の動きが変わることを、実際のプレイで確かめて。 |
| プレイ済み、所蔵、公開カタログの情報を区別してゲームを探せる。[ゲーム管理](https://github.com/KAFKA2306/game-library-dashboard) | 同名作品と別エディションを分けて、プレイ記録と所蔵の根拠を紐づけて。元データと公開一覧で同じ作品を引いて表示を確かめて。 |
| プレイヤーが展示を最後まで回れ、クイズの答えを出典で確かめられる。[奇妙な博物館](https://github.com/KAFKA2306/curious-museum) | 6点の展示をブラウザで回って第7展示室が開くか試して。途中の記録を保存・復元し、展示に書いた答えは各出典に照合して。 |

### 企業・市場の調査

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 半導体の利益と、その前提に使った実績や会社予想を追える。[半導体決算モデル](https://github.com/KAFKA2306/semiconductor-earnings-model) | NANDの平均販売単価とビット出荷を決算期・単位でそろえ、実績、会社予想、シナリオを別々に表示して。公開画面で式と一次開示を開いて。 |
| 投資仮説の成否を同じ条件で再計算できる。[投資仮説の研究基盤](https://github.com/KAFKA2306/investor2) | 対象期間、当時入手できた情報、基準戦略、取引費用を固定して。未使用期間で同じ成績を計算し、崩れる条件と再実行手順を残して。 |
| 景気指標の改定前後を、公式発表に戻って確かめられる。[雇用統計](https://github.com/KAFKA2306/nonfarmpayroll)・[経済指標](https://github.com/KAFKA2306/econalert) | 同じ対象月の初報と改定値を採取し、対象月と公表日を別項目にして。公開CSVとグラフをBLSの各公表値に突き合わせて。 |
| AI企業の売上や上場資料を、同じ定義で比較できる。[AI利用と企業指標](https://github.com/KAFKA2306/finAnalist) | 売上、ARR、年換算の売上を区別して、対象期間と定義を一次開示に添えて。数字の定義がそろう範囲で比較し、前提を変えると結論が変わる箇所を示して。 |

### 科学・製造の調査

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 製造工程の候補を次の試験に持ち込める。[工場・設備の調査](https://github.com/KAFKA2306/factory) | 同じ材料と加工目的の候補を一次資料から探して。何を変え、温度・圧力・速度のどの条件で、歩留まりや欠陥率がどう動いたかを試験表にして。 |
| 電力、宇宙、輸送の実績を公式の発表時点まで追える。[電力](https://github.com/KAFKA2306/Electricity)・[打ち上げ](https://github.com/KAFKA2306/space_launches)・[自動輸送](https://github.com/KAFKA2306/autonomous-logistics) | 公式の統計や履歴から実績を取り直し、予定・認可・試験と区別して。直近の件数や容量を同じ集計期間・単位の公開値に照合して。 |
| 論文の主張と、自分の仕事で試せる条件が分かる。[arXiv調査](https://github.com/KAFKA2306/daily-arXiv-ai-enhanced)・[知識抽出](https://github.com/KAFKA2306/universal-knowledge) | 原著の対象、データ、比較対象、測定値を引用箇所付きで記録して。適用条件が食い違う事例を探し、次に試す再現手順を一つ選んで。 |
| 文章やモデルの性能差を、入力条件の違いから切り分けられる。[文章統計の研究](https://github.com/KAFKA2306/detective) | 評価する日本語の入力と採点条件を固定して、現行と候補を比較して。文の長さや年代で結果を分け、差が消える条件と再実行手順も出して。 |
| ローカルモデルが必要な入力を処理し、実機で使える。[モデル配布と版管理](https://github.com/KAFKA2306/hf-cache-hub) | 同じ日本語と画像の入力を使い、設定ごとの応答、処理速度、最大VRAMを測って。長い入力で再現する失敗も記録し、採用設定を普段の起動コマンドで試して。 |

### Kaggle

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 次の提出に採用するモデルを、同じ検証条件で選べる。[商品価格予測コンペの研究](https://github.com/KAFKA2306/mitsuikaggle) | データの版、時系列分割、公式指標、ベースラインを固定して、仮説を一つ試して。ローカルの結果と公式の提出結果を別々に記録して。メダルを目標にする場合は、最終順位と公式の授与表示で達成を確かめて。 |

### 暮らしと学習

| 欲しい成果 | 依頼文の例 |
| --- | --- |
| 家計の月次集計を元の取引までさかのぼれる。[Kakeibo](https://github.com/KAFKA2306/kakeibo)・[WealthAudit](https://github.com/KAFKA2306/WealthAudit) | 同じ明細を二度取り込んでも件数と合計が変わらないようにして。振替と支出を区別し、差額が出たら該当行に戻れることを手元で確かめて。 |
| 求人や報酬の条件を、原文の条件付きで比較できる。[求人比較](https://github.com/KAFKA2306/salary)・[賞与の比較](https://github.com/KAFKA2306/bonus) | 募集要項の給与、勤務条件、職務範囲を揃え、公式記載と推定値を分けて。気になる項目から求人の原文を開ける比較表にして。 |
| 交通費と宿泊費を含む行程を比較でき、当日は予定を開いて動ける。[旅行計画](https://github.com/KAFKA2306/travel) | 船・鉄道・宿の候補を公式時刻、総額、取消条件で比べて。選んだ行程は現地時刻で並べ、乗り換え時間と予約先を各公式ページで確かめて。 |
| 観たい作品を見つけ、鑑賞に必要な時間や配信条件を確認できる。[アニメの検索](https://github.com/KAFKA2306/anime) | 年、題材、視聴時間で候補を探せるようにして。独自の分類と配信元の情報を区別し、作品ページと配信条件を開いて確かめて。 |
| 手元の本やノートから、読みたい版と出典を見つけられる。[蔵書管理](https://github.com/KAFKA2306/books)・[公開ノートの例](https://scrapbox.io/kafka2512/性格と昇進（Wang_2025）) | 作品、版、所蔵、試し読みを区別して。ISBN、引用箇所、読書メモを結び、同じ作品の別版を検索して読みたいノートに戻れることを試して。 |
| 日々の記録を後から振り返り、予定の変更や抜けを見つけられる。 | 手元の記録を日付と出来事で整理して。日時が変わった予定を照合し、同じ予定を再入力しても重複せず、週ごとの振り返りから元の記録を開けるようにして。 |

<details>
<summary>70件の集計対象</summary>

- 開発・運用（7） `aboutkafka`, `agent-resources`, `com`, `design`, `hf-cache-hub`, `kafstyler`, `prompt-vault`
- 記事・動画・音声（7） `2510youtuber`, `articles`, `gennote`, `kling`, `nlm`, `yt3`, `yt4`
- VRChat・3D・画像制作（15） `AutoPhotogrammetry`, `PictureChangerTools`, `VRChat-bolt`, `VRChatGaussianSplatting`, `boothitemmanager`, `cast_event_cal`, `comfyui-workflows-factory`, `dancer`, `hitaiou`, `image2outfit`, `molecularshader`, `unity-mcp`, `vlog`, `vrcgimmicknetwork`, `vrmine`
- ボードゲーム・ゲーム（7） `TexasSolver`, `boardgamelist`, `bodogenomikata2`, `curious-museum`, `furuyoni`, `rule-scribe-games`, `sts2`
- 企業・市場の調査（14） `LLM_trader`, `NVII`, `econalert`, `etf`, `finAnalist`, `finBI`, `investor`, `investor2`, `mstr`, `nk225seasonality`, `nonfarmpayroll`, `option`, `semiconductor-earnings-model`, `tokenized_assets`
- 科学・製造の調査（12） `Electricity`, `autonomous-logistics`, `autonomous-vehicles`, `daily-arXiv-ai-enhanced`, `detective`, `factory`, `kafin3`, `multiomics`, `pamiq-poker`, `space_launches`, `universal-knowledge`, `uranium`
- Kaggle（1） `mitsuikaggle`
- 暮らしと学習（7） `WealthAudit`, `anime`, `bonus`, `books`, `kakeibo`, `salary`, `travel`

</details>

## スキル

Claude Codeでは `/kafstyler:<名前>`、Codexでは `$` からKafstylerのスキルを選び、Antigravity CLIでは `/<名前>` を使います。

配布の反映を短時間見守る場合や、端末を閉じても定時に処理したい場合は、[常駐エージェントと定期実行](skills/deliver/SKILL.md#常駐エージェントと定期実行)から使う入口を選びます。

| スキル | 用途 |
| --- | --- |
| [`charter`](skills/charter/SKILL.md) | 利用者ができるようになることと合格条件を定める |
| [`humanizer`](skills/humanizer/SKILL.md) | タイトル、見出し、用語、本文を推敲し、根拠を確かめる |
| [`schema`](skills/schema/SKILL.md) | Markdownのfrontmatterを整え、散在する文書を台帳とObsidian Vaultで整理する。台帳、マスター、集計モデルも設計する |
| [`scrutiny`](skills/scrutiny/SKILL.md) | 前提を疑い、重大な欠陥を根拠と影響で示す |
| [`benchmark`](skills/benchmark/SKILL.md) | 実物が合格条件を満たすか確かめ、比較する場合は同じ条件で差を測る |
| [`deliver`](skills/deliver/SKILL.md) | 変更を実装し、利用者の入口から確かめる |
| [`prune`](skills/prune/SKILL.md) | 範囲指定がなければプロジェクト直下を棚卸しし、不要と確認できたファイルやディレクトリを削る |

全スキルで、目標や成果物の前提を [`scrutiny`](skills/scrutiny/SKILL.md) で確かめます。重大な欠陥が見つかれば、元の作業で修正や再確認に使います。[連携手順](AGENTS.md#コマンドの連携)

定期タスクなどプラグインを使えない環境では、[作業規約](AGENTS.md#全作業への適用と自己改善)に従い、正本の版を固定して必要なスキルのMarkdownを使います。

## Unity・VRChatで制作する

汎用Unityは `CoplayDev/unity-mcp`、VRChat Worldsは `swax/UnityMCP-VRC`、VRChat Avatarsは `lighfu/unity-agent` を使用します。制作の共通規約は [AGENTS.md](AGENTS.md#全作業への適用と自己改善) です。

対象のUnity MCP・Agentは各リポジトリの公式手順で接続します。評価は利用者が使うUnity EditorやVRChat SDKで行います。

## 外部スキルとテンプレート

### 成果物の根拠調査と推敲

成果物の各要素について、必要な分野の知識を imozuru で原文まで調べ、採用理由を一文で記録します。yomiyasu で理由文と日本語の説明を整えたあと、反証レビューで理由と根拠が実際の利用場面に合うかを確かめます。作業台帳から該当箇所と根拠を確認できます。[成果物の確認手順](AGENTS.md#成果物の各要素を根拠と照合する)

Claude Code または Codex で、使うクライアントに両スキルを導入します。導入後は新しいセッションで `imozuru` と `yomiyasu` を選べることを確かめます。

```sh
npx skills add MaryCache/imozuru
npx skills add nanaism/yomiyasu
```

[imozuruの導入手順](https://github.com/MaryCache/imozuru) · [yomiyasuの導入手順](https://github.com/nanaism/yomiyasu)

### Googleのフロントエンド設計スキル

KAFKA2306のWeb UIでは、先に[かふかのデザインパターン](BIBLES.md#かふかのデザインパターン)から操作の順番と共通部品を確認します。設計案の検討には、自律開発コマンドからGoogle Gemini DemoLabを使います。Claude Codeでの導入手順は次のとおりです。

```text
/plugin marketplace add google-gemini/demolab
/plugin install demolab@demolab
```

導入後、フロントエンド作業では `/demolab:gemini-frontend-design` を使います。[Gemini DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)

### ComfyUIのワークフローテンプレート

[Workflow選定と採用の基準](BIBLES.md#comfyuiのワークフロー選定)で制作目的に合う候補を探します。公式テンプレートを使う場合は、ComfyUIの `Workflow → Browse Workflow Templates` から開き、必要なモデルを確認して制作環境で出力を試します。[公式テンプレートの使い方](https://docs.comfy.org/interface/features/template) · [テンプレートの正本](https://github.com/Comfy-Org/workflow_templates)

## ミッション・聖典・作業規約

メモや手順書を作るときは、[ノートの管理規約](BIBLES.md#ノートの管理)に沿って、Markdownの先頭に文書の種別、説明、検索用のタグを書きます。出典や確認履歴を記録するときは[OKFの更新手順](skills/schema/SKILL.md#okfに沿って文書を更新確認する)を使います。このリポジトリの[OKF目次](index.md)から、出典を記録した聖典台帳を開けます。

文書が散らばっている場合は「このフォルダの手順書を棚卸しして。現行の手順は一か所にまとめ、旧版の場所と統合先を台帳に残して。Obsidianからタグで探せるようにして」と対象を添えて依頼できます。[台帳とObsidian Vaultで文書を整理する](skills/schema/SKILL.md#台帳とobsidian-vaultで文書を整理する)

- [MISSION.md](MISSION.md) ミッションと更新手順を確認できます。
- [聖典台帳](BIBLES.md) 分野別の一次資料と対応コマンドをたどれます。
- [AGENTS.md](AGENTS.md) 単一ブランチでの作業、逐次コミット、出力の共通ルールを確認できます。
