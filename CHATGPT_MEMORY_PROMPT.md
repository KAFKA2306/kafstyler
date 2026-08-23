# ChatGPT Memory Audit Prompt

Paste the prompt below into ChatGPT when you want to audit its durable memory against the canonical GitHub state.

```text
KAFKA2306/basic_prompts の main ブランチにある MEMORY.md を GitHub から実際に読み、これを durable ChatGPT memory の唯一の正準として扱ってください。

目的は、ChatGPT が保持・参照している長期ユーザー情報を、現在の MEMORY.md と比較し、古い現在値・一時的snapshot・重複・競合を除去しやすい状態にすることです。

まず監査だけを行い、変更はまだ実行しないでください。

各項目を次のいずれかに分類してください。
- KEEP: MEMORY.md と整合し、今後も長期保持する価値がある。
- ADD: ChatGPT 側にある安定情報で、MEMORY.md に追加する価値がある。
- REPLACE: durable rule / preference が更新されており、MEMORY.md の既存項目を置換すべき。
- DELETE: 不要、重複、終了済み、または長期memoryとして不適切。
- MOVE-OUT: 現在値なのでmemoryには保存せず、GitHub / Calendar / Gmail / Web / production / actual file などの source of truth から都度取得すべき。

特に、PR / Issue / branch / SHA / CI / deployment、project進捗、software/model version、価格、市場値、スコア、短期予定、予約、temporary blocker、next action などを durable memory として残さないでください。

比較結果は、現在の MEMORY.md を基準に、ADD / REPLACE / DELETE / MOVE-OUT ごとに具体的な差分候補を示してください。REPLACE は可能な限り `- old` / `+ new` の形で示してください。

事実が現在も有効か外部sourceで確認できるものは、memoryを根拠に現在値を断定せず、必要なら正準sourceを確認してください。

ChatGPT内部のSaved Memory全件を直接列挙・変更できない場合は、できる範囲を明示し、見えていないMemoryを推測して存在すると断定しないでください。

監査結果の最後に、MEMORY.md の変更案とChatGPT側で削除・更新すべき候補を分けて提示してください。私が「実行」と明示した後にだけ、利用可能な機能の範囲で変更を実行してください。
```

`MEMORY.md` contains the durable state. This file contains only the reusable audit/sync instruction and must not duplicate the durable memory values.
