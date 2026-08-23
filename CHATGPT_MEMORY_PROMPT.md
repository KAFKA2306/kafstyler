KAFKA2306/basic_prompts の main/MEMORY.md を GitHub から実際に読み、durable ChatGPT memory の唯一の正準として扱ってください。

現在参照できる ChatGPT 側の長期ユーザー情報と比較し、各項目を次に分類してください。
- KEEP: MEMORY.md と整合する durable item
- ADD: MEMORY.md に追加する価値がある durable item
- REPLACE: 既存 durable item の更新
- DELETE: 不要・重複・終了済み・不適切な item
- MOVE-OUT: 現在値なので source of truth から都度取得すべき item

PR / Issue / branch / SHA / CI / deployment / project進捗 / blocker / next action / 価格 / score / ranking / version / current location / 短期予定 / 予約などの mutable state は durable memory に残さないでください。

まず監査だけを行い、MEMORY.md を基準に ADD / REPLACE / DELETE / MOVE-OUT の具体的な差分を示してください。REPLACE は可能なら `- old` / `+ new` で示してください。

現在値を外部 source で確認できる場合は memory で断定せず、正準 source を確認してください。ChatGPT Saved Memory 全件を直接読めない場合は、見えていない項目を推測して存在すると断定しないでください。

私が「実行」と明示した後だけ変更してください。GitHub 側は MEMORY.md を更新し、ChatGPT Saved Memory を編集できる場合は durable items を複製せず current main/MEMORY.md を読むための pointer だけを残してください。実行できなかった変更は完了と主張せず明示してください。
