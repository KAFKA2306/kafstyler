---
name: deliver
type: "skill"
description: "常駐エージェントの設計・運用、完了までの継続、監視、定期・イベント実行、中断からの再開、機能実装、不具合修正、移行、障害復旧、配布や起動手順の変更では、着手前に必ず使う。利用者の入口で成果を確かめるまで進める。"
tags:
  - kafstyler/skill
  - kafstyler/skill/deliver
aliases:
  - "自律開発"
  - "開発"
  - "常駐エージェント"
generated:
  by: openai/chatgpt
  at: "2026-11-19T10:54:18Z"
verified:
  - by: openai/chatgpt
    at: "2026-11-19T10:48:56Z"
---

# 自律開発

`deliver` は、引き受けた仕事を利用者が成果を確かめられるところまで進める。今できる工程を実行し、待ちが生じたら次の起動条件を設定済みの仕組みに結ぶ。中断しても、最後に確認した成果から再開する。

任意の出力で人が読む文章には[imozの執筆・推敲ルール](../../BIBLES.md#imozの日本語編集)を適用する。[出力の共通基準](../../MISSION.md#出力の共通基準)

## 常駐エージェントと定期実行

[目標設定](../charter/SKILL.md)で、利用者が普段使う入口、そこで観測する合格条件、実行できる時間帯と上限、停止条件を決める。次に、作業を進められるか、外部の変化を待つか、端末が止まっても起動する必要があるかを確認する。[起動と再開の公式仕様](../../BIBLES.md#起動と再開の公式仕様)と手元の版・設定を照合する。

| 実行したいこと | 使う入口 |
| --- | --- |
| 今の依頼を一度完了する | `deliver` を直接実行する。 |
| 実装と検証を繰り返して一件を完了する | 対応する Claude Code・Codex では [継続目標](#一件を合格まで進める)を使う。 |
| CIや配布の反映を、開いているセッションで見守る | Claude Codeでは[公式の `/loop`](#claude-codeの-loop-連携)を使う。既にイベントで次の実行を起動できる場合は、その入口を使う。 |
| ターミナルを閉じたあとも同じ端末で進める | ホストのローカルバックグラウンド機能を使う。Claude Codeでは `/bg` を使い、ターミナルを閉じる前に状態の確認方法と作業ツリーを確かめる。PCの再起動で処理は止まる。 |
| 端末が止まっていても処理する | 一件なら Codex Cloud などのクラウド実行を使う。定期・イベント実行なら Claude Code の `/schedule`、ChatGPT Work の Scheduled など、対象への接続と起動条件を満たす仕組みを使う。 |
| 端末上のファイルやアプリを使って定期実行する | 端末・アプリの稼働が必要な範囲を確認し、既存のデスクトップ定期実行や認可済みのスケジューラーを使う。常駐機能が使えないCLIでは、対応する非対話コマンドを実行入口にする。 |

1. **引き受ける。** [作業台帳](../../AGENTS.md#作業台帳)で同じ案件を探し、新規なら登録する。定期・イベント実行を設定するときは、何が起動を知らせ、どの権限・接続で実行し、誰が結果を読み、どこで停止できるかを決める。登録した設定を読み戻し、ジョブIDや次回の起動条件を台帳に残す。許可された起動手段が使えない場合は、今できる工程を終え、止まった操作と再開条件を記す。
2. **確認してから続ける。** 着手時と再開時に同じ作業IDの台帳を開き、対象・入力の版、実行上限の残り、外部に反映済みの成果、次の工程を確認する。既存セッションは復元できる場合に使う。外部書き込みの前に同じ対象を処理中の実行と、同じ起動による結果を照合する。同じ対象への書き込みは一つずつ進める。応答が途切れた場合は外部の正本から結果を確かめ、反映済みなら同じ成果を使う。反映の有無を確かめられない操作は保留する。[状態の設計](../schema/SKILL.md#定期実行と再開の記録)
3. **待ちから戻る。** 外部ジョブや回答を待つ間も、依存しない工程を先に終える。待っている対象、最後に確かめた状態、次の確認時刻か再開イベントを台帳に残す。権限者の判断が必要な場合は[質問台帳](../schema/SKILL.md#人間の回答を待つ質問の台帳)を使い、回答が届いたときに同じ案件の残りを再開する。失敗が一時的なら、許可された範囲・上限で原因を確かめて再試行する。上限や権限に達したら、未完了の工程と再開条件を残す。
4. **成果を確かめ、監視を終える。** 起動の受付、実行の終了、成果の確認を区別する。利用者の入口から期待した版・内容を読み戻し、合格の証拠と参照先を台帳と既存の報告先に残す。通知や公開の成功を確かめてから処理済みの位置を進め、取得に失敗した場合は最後に確認した位置を保つ。目的を達成・中止した一時ジョブは解除を確認する。定例ジョブは一回分の結果を記録して次回を待ち、運用を止めるときに設定を解除して読み戻す。

常駐運用の合格には、設定した入口から一件を起動し、利用者の入口で成果を読み戻す。[運用での評価](../benchmark/SKILL.md#定期実行と再開の評価)から変更に関わる失敗事例を選ぶ。再開を変えた場合は途中でセッションを切り、同じ案件の次の工程から進むことを確かめる。再試行を変えた場合は外部書き込みの直後に応答を切り、同じ入力で成果が一件に保たれることを確かめる。端末停止中の起動が要件なら、その条件で起動と成果を確認する。

## 一件を合格まで進める

Claude Code・Codexで `/goal` が使える場合は、`deliver` の手順、作業台帳の参照先、利用者の入口で確かめる合格条件、実行上限を渡し、目標の状態を確認する。

```text
/goal deliverを使い、作業台帳の案件42を公開URLで指定版が読めるまで進める。30分で合格しなければ、最後に確認した結果と次の操作を台帳に記録する。
```

即座に進められる工程は現在のセッションで実行する。外部の変化を待つ段階では[起動方法](#常駐エージェントと定期実行)を選び直す。別の起動手段に引き継いだら元の継続目標を停止して状態を確認する。`/goal` が使えない環境でも着手し、合格条件まで進められる範囲と再開の入口を台帳に残す。

## Claude Codeの /loop 連携

短時間の見守りを任された場合に、[公式の `/loop`](../../BIBLES.md#claude-codeのloop)を使う。対象、間隔、止める条件を渡す。

```text
/loop 5m /kafstyler:deliver 配布の反映を待つ。公開URLで指定した版を読めたら終了する
```

1. 登録時の表示または `CronList` でジョブIDを確認する。最初の予定実行で `kafstyler:deliver` が呼び出され、確認対象の状態を読み戻したことを確かめる。呼び出せない場合は、スキルの利用を許可する設定を確認する。各回は同じジョブと案件を引き継ぐ。セッションを再開したときは、台帳と実行中のジョブを照合してから監視を戻す。`/loop` が使えない場合は、現在のセッションで可能な確認を行い、見守りを継続できる範囲を伝える。
2. 合格・中止、または回答やイベントで再開する手段へ引き継いで見守りが不要になったときは、`CronDelete` で対象IDを解除し、`CronList` で確認する。解除に失敗した場合はジョブIDと解除操作を報告する。

## Claude Agent SDKでの実装

Claudeで動くエージェントを実装する場合は、[実行方式の比較](../../BIBLES.md#claude-agent-sdk)で運用に合う方式を選ぶ。Agent SDKでKafstylerを使う場合は、`plugins` に `{ type: "local", path: ... }` を指定し、`path` に使う版のプラグインのルートを渡す。

起動時の `init` メッセージで、`plugins` に `kafstyler`、`skills` に使う `kafstyler:<名前>` があることを確かめる。`allowed_tools`（TypeScriptでは `allowedTools`）はツールを事前承認する。禁止するツールや操作は `disallowed_tools`（`disallowedTools`）などで設定する。アプリの入口から、通常の依頼が完了し、禁止した操作が拒否されることを確かめる。

## Antigravity CLIでレビューする

別のエージェントから Antigravity CLI にレビューを頼む場合は、[配布版の導入](../../README.md#antigravity-cli)と[公式仕様](../../BIBLES.md#antigravity-cliの配布と実行)を確認する。ジョブを実行する環境とユーザーで認証し、`agy models` で使えるモデルIDを確かめる。レビュー対象、求める指摘と根拠、変更してよい範囲を依頼に含める。入力は、その認証先に送る許可がある資料に絞る。

秘密のないディレクトリで、Neonを指定した一往復を確かめる例。

```sh
agy -p "文字列 antigravity を逆順にし、結果だけ返して。" --model gemini-4-neon-high --output-format json --print-timeout 5m
```

疎通の合格条件は終了コード `0`、JSONの `status` が `SUCCESS`、`response` が `ytivargitna`。実作業では標準エラーも保持する。承認が必要なツール操作がヘッドレス実行で拒否されても、終了コード `0` で続く場合がある。必要な操作が行われたことを確認し、指摘を対象の行や実際の操作結果と突き合わせる。

## 実装と検証

1. プロジェクトの現状、利用者が使う入口、合格条件を確認する。[`kafstyler:charter`](../charter/SKILL.md) で完成場面を決め、設計に進む前に [`benchmark`](../benchmark/SKILL.md#設計前に評価を決める) の固定済み評価を確認する。進行中のIssueやPRがあればその作業を引き継ぐ。データ構造の設計が必要なら、[`kafstyler:schema`](../schema/SKILL.md) を呼ぶ。答える問い、実データの例、変更範囲を渡し、結果を実装に使う。作業を分けるときは、各単位の担当、成果物、合格条件を決める。人間による認証が必要な場合は、事前確認を済ませ、必要な操作と再開条件を伝える。
2. 実際の障害を確認し、役割を終えた経路や重複を除く。標準の道具と公式APIを使い、依頼に必要な変更単位を選ぶ。フロントエンドではプロジェクトのデザイン規則に従う。KAFKA2306のWeb UIでは、[かふかのデザインパターン](../../BIBLES.md#かふかのデザインパターン)から設計・同期の手順を開き、操作パターンと共通部品を選ぶ。共有デザインの導入・更新を含む場合は採用版を固定し、正本の手順で同期と適合確認を行う。設計案の検討には、利用できる場合は `demolab:gemini-frontend-design` を使う。[目標設定](../charter/SKILL.md)で決めた操作を、利用者が使う画面幅で入口から完了まで確かめる。[DemoLabの公式手順](https://github.com/google-gemini/demolab#claude-code)
3. 現行方式の前提や置き換え候補の反証が依頼に含まれる場合は、[`kafstyler:scrutiny`](../scrutiny/SKILL.md) を呼ぶ。検証する前提、観測された問題、置き換えの条件を渡す。手法を置き換える場合は、[`kafstyler:benchmark`](../benchmark/SKILL.md) を呼び、現行と候補、共通の入力、設計前に固定した評価を渡す。評価で合格し、品質や運用工数が改善し、保守と検証の根拠がある候補を採用する。通常の入口で移行後の動作を確認したら、[`kafstyler:prune`](../prune/SKILL.md) を呼び、置き換えた旧実装、整理の範囲、移行時の評価結果を渡す。
4. ComfyUIでは最初に[Workflow選定と採用の基準](../../BIBLES.md#comfyuiのワークフロー選定)を読み、制作目的に合う候補と採用条件を確認する。公式テンプレートは `Workflow → Browse Workflow Templates` から開く。候補の版と必要モデルを記録し、制作環境で出力を確かめる。[Unity・VRChat制作](../../BIBLES.md#ユニティとvrchatの制作ツール)では用途に合うツールを選び、対象プロジェクトで確かめる。シェルでは一つのコマンドに一つの仕事を任せ、標準入出力でつなぐ。
5. [固定した評価](../benchmark/SKILL.md#固定した評価で採否を決める)を利用者の入口から実物に実行し、全必須項目が自動判定で合格するまで、完了判定と配布を保留する。新しいワークフロー、CI、テスト、スクリプト、フックは具体的な失敗を検出するか、実測した繰り返し作業を減らす場合に加える。整理では重複した確認を取り除き、削減した件数や工数を測る。
   - [実物を使う検証](../../BIBLES.md#claude-codeの検証)では、ローカルで動かせる安価な検査から始める。続けて、対象を起動し、普段の入口に代表入力を与え、最後に表示や保存先を読み戻す。失敗時は対象の版、止まった操作、期待した結果、ログや画面の観測を残す。繰り返し使う起動と確認手順は対象に近い既存の文書やスキルへ置く。
   - 新しい必須チェックを作る場合は、まず条件に該当した結果を記録し、誤検知を確かめてから必須化を判断する。失敗したら原因を調べて修正し、その影響範囲を再検証する。解消できないときは再現手順、試した修正と観測、判断が必要な点を残す。記録した見逃しのうち、差分と再現手順で判定できるものは既存の検証やレビュー手順の改善候補にする。
6. [共通の連携手順](../../AGENTS.md#コマンドの連携)に従い、配布前に [`kafstyler:scrutiny`](../scrutiny/SKILL.md) を呼ぶ。変更後の実物、普段の入口、合格条件と検証結果を渡す。通常利用、途中失敗、再試行で成果が成り立つかを確かめ、確認できた重大な欠陥を直し、同じ自動判定で合格を確かめてから対象リポジトリの規約に従って配布する。Kafstylerでは[作業規約](../../AGENTS.md#ブランチとコミット)に従い、同じチェックアウトで作業し、確認した変更単位ごとに `main` にコミットする。PRを使うリポジトリでは差分、マージ、反映、後片付けまで確認する。公開する変更では、対象コミットから生成した成果物を、公開先が実際に返したファイルや版と照合する。その公開先で利用者の操作を最後まで通す。成果物が古ければビルド設定と配信先を調べる。

動作する変更と根拠を届ける。実行を妨げる問題が残る場合は次の作業を示す。

## 関連ミッション

[自律改善](../../MISSION.md#自律改善)・[自律成果創出](../../MISSION.md#自律成果創出)・[外部手法への置き換え](../../MISSION.md#外部実装への置き換え)

## 参照資料

- [Anthropic・Agent Skills執筆ガイド](../../BIBLES.md#スキルの執筆)
- [Anthropic・Claude Code Skills](../../BIBLES.md#claude-codeのスキル)
- [Anthropic・Claude Codeプラグインの作成](../../BIBLES.md#プラグインの作成)
- [Anthropic・プラグインの構成要素](../../BIBLES.md#プラグインの構成)
- [Anthropic・プラグインマニフェスト仕様](../../BIBLES.md#プラグインのマニフェスト)
- [Anthropic・Claude Codeの実践ガイド](../../BIBLES.md#claude-codeの実践)
- [Pydantic・検証の公式ドキュメント](../../BIBLES.md#pydanticのデータ検証)
- [Astral・uv](../../BIBLES.md#uvの環境管理)
- [Astral・Ruff](../../BIBLES.md#ruffの静的解析)
- [Astral・ty](../../BIBLES.md#tyの型検査)
- [Google Gemini・DemoLabのフロントエンド設計スキル](../../BIBLES.md#googleの画面設計)
- [ComfyUI・公式ドキュメント](../../BIBLES.md#comfyuiの公式文書)
- [ComfyUI・Workflow Templatesの使い方](../../BIBLES.md#comfyuiのテンプレート)
- [ComfyUI・公式テンプレートの正本](../../BIBLES.md#comfyuiのテンプレート正本)
- [ComfyUI・Workflow JSON仕様原本](../../BIBLES.md#comfyuiのワークフロー形式)
- [Pulumi・Infrastructure as Code](../../BIBLES.md#pulumiの構成管理)
- [Pulumi・変更の事前確認（pulumi preview）](../../BIBLES.md#pulumiの差分確認)
- [Tripo Studio・公式ドキュメント](../../BIBLES.md#tripo-studio)
- [Tripo API・公式ドキュメント](../../BIBLES.md#tripoのapi)
- [Tripo・ComfyUIノードの公式ドキュメント](../../BIBLES.md#tripoのcomfyui連携)
- [Tripo / VAST AI・論文一覧](../../BIBLES.md#tripoの研究一覧)
- [Microsoft・General Naming Conventions](../../BIBLES.md#命名規則)
- [DeepSeek Harness・公式開発者ドキュメント](../../BIBLES.md#deepseek-harnessの使い方)
- [DeepSeek Harness・アーキテクチャ](../../BIBLES.md#deepseek-harnessの構成)
- [McIlroy・Pinson・Tague「UNIX Time-Sharing System: Foreword」（1978）](../../BIBLES.md#unix哲学)
- [汎用Unity・CoplayDev/unity-mcp](../../BIBLES.md#ユニティの汎用mcp)
- [VRChat Worlds・swax/UnityMCP-VRC](../../BIBLES.md#vrchatのワールド制作)
- [VRChat Avatars・lighfu/unity-agent](../../BIBLES.md#vrchatのアバター制作)
- [Agent Skills・仕様](../../BIBLES.md#エージェントスキルの仕様)
- [Model Context Protocol・Tools](../../BIBLES.md#mcpのツール仕様)
- [OpenAI・Harness engineering](../../BIBLES.md#openaiのハーネス設計)
- [Anthropic・Effective harnesses for long-running agents](../../BIBLES.md#長時間稼働するエージェント)
- [Chip Huyen・AI Engineering](../../BIBLES.md#aiエンジニアリングの書籍)
- [Manning・Agent Engineering](../../BIBLES.md#エージェント設計の書籍)
- [かふかのZenn記事一覧](../../BIBLES.md#かふかのzenn記事一覧)
- [ISUCON2026 で優勝しました（準備編）](../../BIBLES.md#isuconの準備)
- [fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](../../BIBLES.md#isuconの優勝ハーネス)
- [OpenAI・現場で成果を届けるエンジニアリング（What FDE means at OpenAI）](../../BIBLES.md#openaiの現場開発)
- [Issue駆動開発](../../BIBLES.md#issue駆動開発)
- [個人開発の次の一件](../../BIBLES.md#個人開発の次の一件)
- [自動テストの合格条件](../../BIBLES.md#自動テストの合格条件)
- [WindowsでのGemini CLI導入](../../BIBLES.md#windowsでのgemini-cli導入)
- [エージェント向け運用基盤](../../BIBLES.md#エージェント向け運用基盤)
- [AstralのPython開発基盤](../../BIBLES.md#astralのpython開発基盤)
- [SteamVRの起動障害](../../BIBLES.md#steamvrの起動障害)
- [WSL2でのAntigravity導入](../../BIBLES.md#wsl2でのantigravity導入)
- [Taskで共通の実行手順を作る](../../BIBLES.md#taskで共通の実行手順を作る)
- [WindowsとWSLの自動化](../../BIBLES.md#windowsとwslの自動化)
- [WSL2でのUnity Hub導入](../../BIBLES.md#wsl2でのunity-hub導入)
