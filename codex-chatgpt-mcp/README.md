# ChatGPT → Codex CLI over official MCP

ChatGPT を親エージェント、ローカル Codex CLI を子エージェントとして扱うための最小構成です。

## Canonical architecture

```text
ChatGPT web
   │ MCP tool call: codex / codex-reply
   ▼
OpenAI Secure MCP Tunnel
   │ outbound HTTPS only
   ▼
openai/tunnel-client (Windows, local)
   │ stdio
   ▼
OpenAI Codex CLI: codex mcp-server
   │
   ▼
local repositories / tools
```

独自MCPサーバー、GitHub Issue inbox、Webhook中継は使いません。

## Upstream components

- OpenAI Codex CLI / `codex mcp-server`: https://developers.openai.com/codex/mcp-server
- OpenAI Secure MCP Tunnel: https://developers.openai.com/api/docs/guides/secure-mcp-tunnels
- OSS tunnel client: https://github.com/openai/tunnel-client (Apache-2.0)
- OSS Codex: https://github.com/openai/codex

`codex mcp-server` は MCP の `codex` と `codex-reply` tools を公開します。ChatGPT が `codex` を呼べば、Codex の最終結果と `threadId` を同じ MCP response で受け取り、必要なら `codex-reply` で継続できます。

## One-time credential boundary

完全自動運転の前に、OpenAI の認証境界として次の2点だけは本人操作が必要です。秘密情報はリポジトリへ保存しません。

1. OpenAI Platform の Tunnels で tunnel を作成し `tunnel_id` を取得する。
2. Tunnels Read + Use を持つ runtime API key を作成する。

Platform: https://platform.openai.com/settings/organization/tunnels

その後、PowerShell で一度だけ:

```powershell
./install.ps1 -TunnelId 'tunnel_...' -RuntimeApiKey 'sk-...'
```

`install.ps1` は以下を自動化します。

- ローカル Codex CLI / `codex mcp-server` の存在確認
- `openai/tunnel-client` の GitHub latest release から Windows binary を取得
- API key を Windows DPAPI でユーザー暗号化して保存
- tunnel profile を `codex mcp-server` 向けに生成
- `tunnel-client doctor` 実行
- Windows ログオン時の Scheduled Task を作成
- tunnel daemon を即時起動

## Connect ChatGPT once

ChatGPT 側では Developer mode で一度だけ developer app を作り、Connection に **Tunnel** を選択して上記 `tunnel_id` を選びます。

接続後は、ChatGPT が Codex を直接 MCP tool として呼べます。以後、ユーザーが Codex CLI の出力をコピーして ChatGPT に貼り戻す必要はありません。

## Operating rule

ChatGPT → Codex の実行では原則として:

- `cwd` を対象 repo の絶対パスに固定する
- 通常は `sandbox=workspace-write`
- 通常は `approval-policy=never` ではなく、必要な権限をタスク境界に応じて選ぶ
- Codex の返却 `threadId` を保持し、同一作業の追試・修正は `codex-reply` を使う
- GitHub / CI / test の完了証拠まで Codex に返させ、ChatGPT が最終判定する

## Security boundary

- runtime API key は GitHub に commit しない
- `~/.codex/auth.json` を転送しない
- inbound firewall port を開けない
- tunnel-client は OpenAI への outbound HTTPS と local stdio のみを使用する
- Scheduled Task は現在の Windows user で動かす
