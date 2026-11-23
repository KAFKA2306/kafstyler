---
type: reference
description: "使命・評価・執筆の一次資料と判断基準"
tags:
  - kafstyler/canon
  - kafstyler/reference
---

# 使命・評価・執筆

## 目標・文章・評価

### MISSIONとIssueによる案件選定

使命から実行と検証をつなぐときは、**目的と成果の基準**、**個別作業の追跡**、**完成・不採用の判定**を分ける。

| 一次資料 | Kafstylerでの採用判断 |
| --- | --- |
| [Google Cloud・AI/ML Operational excellence](https://docs.cloud.google.com/architecture/framework/perspectives/ai-ml/operational-excellence)（2026年10月29日レビュー） | 解く問題と必要な成果を最初に定め、目的を測定可能な結果へ結び付ける。`reconceptualize` がMISSIONへの寄与を判断し、`adjudicate` が成果を測る。 |
| [GitHub・About issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/about-issues)（公式仕様） | Issueを問題・意見・作業の単位として使う。MISSIONや実物の成果をIssueに置き換えず、`canonicalize` が相互参照を保つ。 |
| [GitHub・Planning and tracking work](https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/planning-and-tracking-work-for-your-team-or-project)（公式ガイド） | 大きな仕事だけ必要な粒度に分割し、Issue間の依存関係をたどる。`autocatalyze` が実行順を決め、Issue数を成果としない。 |
| [GitHub・Closing an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/closing-an-issue)（公式仕様） | 解決済みと実行予定なしを区別する。`autocatalyze` は確認した成果を紐付けて閉じ、`decommission` は重複・不要な仕事を整理する。 |

[共通運用](../AGENTS.md#missionとissueの運用) · [自律開発](../skills/autocatalyze/SKILL.md#missionに沿ったissue駆動) · [正本の統一](../skills/canonicalize/SKILL.md#missionとissueの正本関係)

### 問題の再定義と利用者の目的

[Design Council・Double Diamond](https://www.designcouncil.org.uk/resources/the-double-diamond/)（設計原典）。解決策の前に問題を探索・定義する。[GOV.UK・Solve a whole problem for users](https://www.gov.uk/service-manual/service-standard/point-2-solve-a-whole-problem)（公式基準）。利用者が一連の用事を完了できるか確かめる。

[Anthropic・Trustworthy agents in practice](https://www.anthropic.com/research/trustworthy-agents)（エージェントの自律性と監督に関する研究）。個々の可逆的な操作では自律性を生かし、利用者の目的が不明な判断や重大な変更では上位の方針と権限を確認する。質問を増やすことと、必要な判断を得ることを区別する。

[目標設定](../skills/reconceptualize/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md)

### 自律的な問題発見と概念再構築

`reconceptualize` は要求された解決策を順位付けする前に、実績、再発、利用のつまずき、維持費、既存の機能が生む負担から**取り組む価値がある問題**を見つける。発見した事実と原因の仮説を分け、現状維持・削除・再利用・根本的な再設計を比較する。採用した案は `autocatalyze` に渡し、実測の変化から問題設定自体の妥当性を評価する。

| 一次資料 | Kafstylerで使う判断 |
| --- | --- |
| [Donald A. Schön・The Reflective Practitioner](https://books.google.com/books?id=oYNHAAAAMAAJ)（1983年、原著の書誌） | 与えられた課題の解決以前に、何を問題として設定したのかを問い直す。 |
| [Kees Dorst・Frame Innovation](https://mitpress.mit.edu/9780262328852/frame-innovation/)（MIT Press、2015年） | 既存解決策の改良と、問題の捉え方を変更する案を明確に分ける。 |
| [Ackoff、Magidson、Addison・Idealized Design](https://www.oreilly.com/library/view/idealized-design-creating/0131963635/ch01.html)（2006年、原著第1章） | 現行機能から積み上げるだけでなく、望ましい完成状態から必要な構造を考える。 |
| [Chris Argyris・Double Loop Learning in Organizations](https://hbr.org/1977/09/double-loop-learning-in-organizations)（Harvard Business Review、1977年） | 期待した成果が出ないとき、実装の修正だけでなく目標・前提・判断基準まで戻る。 |
| [Richard Hamming・You and Your Research](https://www.cs.virginia.edu/~robins/YouAndYourResearch)（1986年講演の記録） | 簡単に片付く仕事ではなく、影響が大きく進展可能な問題を選ぶ。 |
| [Teresa Torres・Prioritize Opportunities, Not Solutions](https://www.producttalk.org/prioritize-opportunities/)（2019年、著者の記事） | Issueや機能案の前に、利用者の未充足の用事・障害を選定する。 |
| [Jeongほか・TIDE: Proactive Multi-Problem Discovery via Template-Guided Iteration](https://arxiv.org/abs/2606.04743)（2026年、研究論文） | 明示されていない問題を証拠付きで探索する。発見済みの証拠を次の探索に引き継ぎ、重複した問題の列挙を避ける。 |
| [Gloaguenほか・Coding Agents Don't Know When to Act](https://www.sri.inf.ethz.ch/publications/gloaguen2026coding)（2026年、FixedBench） | 既に解決した問題や修正不要な状態を見分け、何もしない判断を成功に含める。 |
| [SWE-sweep](https://swesweep.com/)（2026年、研究・評価基盤） | 具体的な修正箇所を与えない状況で、実際に問題を発見・修復できるかを評価する。 |

これらは同じ証拠水準ではない。書籍・講演・設計記事は問題設定の方法論、TIDE・FixedBench・SWE-sweepはAIエージェントの観測・評価に使う。研究結果をKafstylerでの改善実績と取り違えず、実際の利用結果で採否を確かめる。

[概念再構築](../skills/reconceptualize/SKILL.md#自律的に問題を発見して再構築する) · [継続実行と案件選定](../skills/autocatalyze/SKILL.md#常時稼働エージェントの中核)

### 評価指標のすり替えと独立した検証

- [Google DeepMind・Specification gaming](https://deepmind.google/blog/specification-gaming-the-flip-side-of-ai-ingenuity/)（開発元の事例）。指標を満たしても本来の目的を達成しない問題を扱う。
- [OpenAI・Evaluation best practices](https://developers.openai.com/api/docs/guides/evaluation-best-practices)（公式ガイド）。評価入力と実装を分離する。
- [OpenAI・How we monitor internal coding agents for misalignment](https://openai.com/index/how-we-monitor-internal-coding-agents-misalignment/)（開発元の事例）。テスト操作や監視の限界を踏まえる。
- [Center for Open Science・Preregistration](https://www.cos.io/initiatives/prereg)（研究手法の原典）。探索と確証の判定条件を区別する。

[評価と比較](../skills/adjudicate/SKILL.md) · [反証レビュー](../skills/disprove/SKILL.md)

### 合成回答と人間の判断を区別する

- [Maierほか・LLMs Reproduce Human Purchase Intent via Semantic Similarity Elicitation of Likert Ratings](https://arxiv.org/abs/2510.08338)（PyMC Labs・Colgate-Palmolive共同研究、arXiv v3、2025年）。LLMの自由記述を意味類似性で5段階の回答分布に変換するSSRを、57件の商品コンセプト調査・実回答者9,300人で比較した。商品間の購買意向平均の相関は、人間の回答者を二分した場合の相関の約90%に達したが、実際の購買の予測精度ではない。回答の変換に使う基準文は同じ57調査に合わせて調整されており、別の商品群で同じ精度になるかは確かめられていない。
- [Bisbeeほか・Synthetic Replacements for Human Survey Data? The Perils of Large Language Models](https://www.cambridge.org/core/journals/political-analysis/article/synthetic-replacements-for-human-survey-data-the-perils-of-large-language-models/B92267DC26195C7F36E63EA04A47D2FE)（Political Analysis、2024年）。政治意識調査では合成回答の平均が実調査に近くても、回答のばらつきや属性との関係が食い違い、実際の回答者の代理として推論すると結論が変わった。SSRそのものの追試ではない。回答分布の一致だけでなく、意思決定に必要な関係を実測で照合する。
- [AAPOR・Making Good Choices—and Explaining Them](https://aapor.org/announcements/making-good-choices/)（米国世論調査研究協会、2026年）。AIが生成した回答を人間から回収した回答と区別し、生成・検証の方法を明示する。ペルソナ別の模擬回答は仮説の発見に使い、利用者の需要や行動を確定する根拠には実際の人間による観測を用いる。

[評価と比較](../skills/adjudicate/SKILL.md) · [反証レビュー](../skills/disprove/SKILL.md) · [利用者の目的](../skills/reconceptualize/SKILL.md)

### 減算による解決

- [Adamsほか・People systematically overlook subtractive changes](https://www.nature.com/articles/s41586-021-03380-y)（Nature誌の人間行動研究）。削除案を明示的に探す。AIの性質を直接実証した研究ではない。
- [Martin Fowler・Yagni](https://martinfowler.com/bliki/Yagni.html)（設計原典）。不要な機能を先回りして足さない。
- [Google SRE・Eliminating Toil](https://sre.google/workbook/eliminating-toil/)（公式手引き）。作業の自動化だけでなく発生源を取り除く。

[不要なファイル・コード・文章の削除](../skills/decommission/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md)

### 登大遊の論理的思考

[登大遊・論理的思考の放棄](https://softether.hatenadiary.org/entry/20070324/p1)（原典）。完成時の利用場面を先に思い描く。整理では、完成像と現状の差から候補を見つけ、普段の入口で変更の結果を確かめる。

[目標設定](../skills/reconceptualize/SKILL.md)・[不要なファイル・コード・文章の削除](../skills/decommission/SKILL.md)

### Claude Codeの実践

[Anthropic・Claude Codeの実践ガイド](https://code.claude.com/docs/en/best-practices)（公式ガイド）。依頼の範囲、検証、作業の進め方

[目標設定](../skills/reconceptualize/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md)

### Claude Codeの検証

[Addy Osmani・How the Claude Code team thinks about verification](https://claude.dev/blog/how-the-claude-code-team-thinks-about-verification/)（Claude Codeチームの公式技術記事、2026年11月16日公開、11月19日確認）。

- 利用者の入口から実物を最後まで動かす。入力にかかわらず守る条件は性質ベースのテストで試し、挙動を保つ移行は旧版と新版に同じ入力を与えて比べる。
- 実装前に、依頼と変更前の信頼できる版から、期待する結果と合格条件を決める。検証では対象の版を固定し、手間の少ない確認から始める。過去の障害に基づく検査は、変更内容に関係するものを選ぶ。観測した結果は次のレビューに引き継ぐ。
- 必須にするチェックの候補は、合否の判定に使う前に実行結果を記録し、誤検知を調べる。実際の障害と安定していた変更で検証手順を試し、見逃しを再現できたら手順を直す。重複や不安定な判定も定期的に見直す。

| スキル | 適用する工程 |
| --- | --- |
| [reconceptualize](../skills/reconceptualize/SKILL.md) | 作業前に入口、入力、最後に観測する結果を決める |
| [didactization](../skills/didactization/SKILL.md#本文の推敲と提出前の確認) | 原意と出典を守り、読者の入口で推敲稿と教材の再現性を確かめる |
| [canonicalize](../skills/canonicalize/SKILL.md#完了条件) | 読み書きの契約、旧データとの互換、再処理を確かめる |
| [disprove](../skills/disprove/SKILL.md) | 対象版と判定基準を固定し、差分から過去の失敗を選ぶ |
| [decommission](../skills/decommission/SKILL.md) | 削除前後に利用経路と、残した検査が拾う失敗を確かめる |
| [adjudicate](../skills/adjudicate/SKILL.md#検証手順の評価) | 不変条件と旧版との比較を設計し、評価手順自体の精度も測る |
| [autocatalyze](../skills/autocatalyze/SKILL.md#実装と検証) | 既存の検査を先に実行し、普段の入口から結果を読み戻す |

### 成功基準と評価

[Anthropic・成功基準と評価の設計](https://platform.claude.com/docs/en/test-and-evaluate/develop-tests)（公式ガイド）。成功条件、テストケース、採点方法

[GOV.UK・利用者テスト](https://www.gov.uk/service-manual/user-research/using-moderated-usability-testing)（公式手引き）。文書、ツール、画面の用途が分かりづらいときは、普段の入口で初見の理解と作業の完了をそれぞれ確かめる。利用者には目標を伝え、手順は伏せる。評価では、対象の版、止まった箇所、観察した事実、利用者への影響、修正後の合格条件を返す。用途を確認できない場合は未確定とし、試せた範囲を伝える。

[評価と比較](../skills/adjudicate/SKILL.md) · [反証レビュー](../skills/disprove/SKILL.md)

### imozの日本語編集

[imoz・日本語の文章編集ガイド](https://imoz.jp/humanizer.ja.txt)（編集ガイド）。人が読む文章の執筆と推敲

[評価と比較](../skills/adjudicate/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md) · [データ設計](../skills/canonicalize/SKILL.md) · [反証レビュー](../skills/disprove/SKILL.md) · [知見の教材化と推敲](../skills/didactization/SKILL.md) · [目標設定](../skills/reconceptualize/SKILL.md) · [不要なファイル・コード・文章の削除](../skills/decommission/SKILL.md)

### 読者から記事を設計する

- [英国国家統計局・Designing content to meet user needs](https://service-manual.ons.gov.uk/content/writing-for-users/user-needs)（公式編集ガイド）。読者が何をしたいかを根拠から把握し、何ができれば記事がその用事に応えたといえるかを執筆前に決める。
- [Nielsen Norman Group・The Layer-Cake Pattern of Scanning Content on the Web](https://www.nngroup.com/articles/layer-cake-pattern-scanning/)（視線計測の研究報告）。見出しを拾い読みして必要な本文を探す行動を踏まえ、見出しだけでも答えの場所を見つけられるかを確かめる。

[知見の教材化と推敲](../skills/didactization/SKILL.md#記事を読者から設計する)

### 知見を残す記事の基準

- [GOV.UK・Understand content design](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/plan-manage-content/understand-content-design/)（英国政府の公式編集ガイド）。執筆前に読者の用事を確かめ、新規記事を作るか既存記事を更新・統合するか判断する。
- [Meinckeほか・ChatGPT decreases idea diversity in brainstorming](https://www.nature.com/articles/s41562-025-02173-x)（Nature Human Behaviour、2025年）。ブレーンストーミングで案の質が高まっても、集合としての多様性が下がる場合がある。文章一般への証明とは扱わず、独自の観測のない記事が既存記事と重複しないか確認する際に参照する。
- [Huangほか・Large Language Models Cannot Self-Correct Reasoning Yet](https://proceedings.iclr.cc/paper_files/paper/2024/hash/8b4add8b0aa8749d80a34ca5d941c355-Abstract-Conference.html)（ICLR 2024）。外部フィードバックなしの推論の自己訂正には限界がある。記事の正確さは原資料・実行結果・独立した判定で確かめる。ただし、すべてのモデル・課題で自己訂正が不可能という主張ではない。

[教材化と改稿](../skills/didactization/SKILL.md#発見を汎用原則に変える) · [規則の費用対効果](../AGENTS.md)

### 技術白書の執筆

- [George Mason University Writing Center・White Papers](https://writingcenter.gmu.edu/writing-resources/different-genres/white-papers)（大学の執筆ガイド）。白書を問題と解決策の検討として構成し、判断基準、代替案、根拠、推奨を必要に応じて示す。販売促進を目的とする白書とは区別する。
- [NIST・Technical Series Publications Author Instructions](https://www.nist.gov/nist-research-library/nist-technical-series-publications-author-instructions)（米国国立標準技術研究所の技術報告作成指針）。要旨、本文、参考文献、図表、単位、版の扱いを参考に、主張を一次資料・測定条件・結果へたどれるようにする。NIST固有の出版手続きは一般の白書に適用しない。

[技術白書を書く](../skills/didactization/SKILL.md#技術白書を構成する) · [評価と比較](../skills/adjudicate/SKILL.md) · [反証レビュー](../skills/disprove/SKILL.md)

### 成果物の根拠と読みやすさ

- [MaryCache・imozuru](https://github.com/MaryCache/imozuru)（公式リポジトリ）。分野の用語、文献、引用をたどり、判断を支える原文の場所を調べる。
- [nanaism・yomiyasu](https://github.com/nanaism/yomiyasu)（公式リポジトリ）。主張と条件を保ち、人が読む日本語を推敲する。

[成果物の確認手順](../AGENTS.md) · [導入手順](../README.md) · [反証レビュー](../skills/disprove/SKILL.md#成果物の理由を確かめる)



## AIエンジニアリングの書籍

### AI Engineering（Chip Huyen）

[Chip Huyen・AI Engineering](https://www.oreilly.com/library/view/ai-engineering/9781098166298/)（書籍）。基盤モデルを使うアプリケーションの設計と評価

[自律開発](../skills/autocatalyze/SKILL.md) · [評価と比較](../skills/adjudicate/SKILL.md)

### エージェント設計の書籍

[Manning・Agent Engineering](https://www.manning.com/books/agent-engineering)（書籍）。自律性の設計、ツール連携、評価とフィードバック

[自律開発](../skills/autocatalyze/SKILL.md) · [評価と比較](../skills/adjudicate/SKILL.md)


## ISUCONのハーネス

### ISUCONの準備

[ISUCON2026 で優勝しました（準備編）](https://zenn.dev/luvtechno/articles/isucon2026-preparation)（当事者の実践記録）。素の構成を先に測り、追加した知識や道具の効果を同じ課題で比較する。

[評価と比較](../skills/adjudicate/SKILL.md) · [自律開発](../skills/autocatalyze/SKILL.md)

### ISUCONの優勝ハーネス

[fukabori.fm 第142回「ISUCON2026で優勝する方法 w/ kawasy」](https://fukabori.fm/episode/142)（当事者インタビュー）。長時間の自律実行、競技用ハーネスを小さくした経緯、計測と停止の判断を参照する。

[自律開発](../skills/autocatalyze/SKILL.md) · [評価と比較](../skills/adjudicate/SKILL.md)
