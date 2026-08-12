# ChatGPT ↔ Codex CLI Autonomous Bridge

## Purpose

ChatGPT からローカルの OpenAI Codex CLI にタスクを渡し、Codex の最終結果を ChatGPT が自律的に受け取って次の判断へ進めるための bridge。

現在の ChatGPT Plus では custom MCP developer mode が公式提供対象ではないため、Plus で成立する正準線として **private GitHub Issue queue** を使う。

```text
ChatGPT
  │ GitHub connector: controller task
  ▼
private GitHub Issue #1
  │ official gh CLI
  ▼
Windows bridge daemon
  │ official codex exec
  ▼
Codex CLI
  │ final response + exit code + git evidence
  ▼
private GitHub Issue #1
  │ ChatGPT hourly condition watch
  ▼
ChatGPT verifies → next Codex task or user notification
```

## Components

- OpenAI Codex CLI: https://github.com/openai/codex
- GitHub CLI: https://cli.github.com/
- Queue: `KAFKA2306/basic_prompts` private Issue #1
- ChatGPT GitHub connector
- ChatGPT automation `Codex Bridge Loop`

No custom webhook server is required. No API token is committed to the repository.

## Install once on Windows

Prerequisites:

```powershell
codex --version
gh --version
gh auth status
```

Then clone this private repo and run the installer:

```powershell
$dst = Join-Path $env:TEMP 'basic_prompts-codex-bridge'
Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
gh repo clone KAFKA2306/basic_prompts $dst
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$dst\codex-chatgpt-bridge\install.ps1"
```

The installer:

1. verifies `codex`, `gh`, GitHub authentication, and private Issue access;
2. copies the daemon and supervisor to `%LOCALAPPDATA%\OpenAI\CodexChatGPTBridge`;
3. registers a Windows logon Scheduled Task;
4. starts the supervised daemon immediately;
5. creates a temporary local Git repository;
6. queues a no-write smoke test through Issue #1.

Expected end-to-end worker result:

```text
BRIDGE_OK
```

with `exit_code: 0`.

## Queue protocol

### ChatGPT → Codex

```md
<!-- codex-bridge:v1 role=controller task=<unique-task-id> -->

```json
{"cwd":"D:\\absolute\\repo","prompt":"Precise Codex task"}
```
```

### Codex → ChatGPT

```md
<!-- codex-bridge:v1 role=worker task=<same-task-id> -->
```

The worker response includes:

- Codex exit code
- absolute `cwd`
- Git repository root when available
- `HEAD` SHA when available
- bounded `git status --porcelain=v1`
- Codex final message from `--output-last-message`

Raw `--json` event output remains local under the bridge runtime directory.

## Runtime behavior

- daemon polls the private Issue every 30 seconds;
- processed task IDs are persisted locally and capped to the latest 1000 IDs;
- GitHub comments are fetched with official `gh api --paginate --slurp`;
- Codex prompt is passed through stdin to avoid Windows command-line length limits;
- supervisor restarts the daemon if it exits;
- Windows Scheduled Task starts the supervisor at user logon.

## Security boundary

- queue repository is private;
- GitHub authentication stays in the official GitHub CLI credential store;
- Codex authentication files and API keys are never copied into Issue comments;
- raw Codex JSONL stays on the local machine;
- bridge posts only final text plus bounded execution/Git evidence;
- high-risk or irreversible follow-up actions remain subject to ChatGPT-side approval rules.

## Direct MCP upgrade path

OpenAI's direct architecture is:

```text
ChatGPT custom MCP app
  ↕ OpenAI Secure MCP Tunnel
openai/tunnel-client
  ↕ stdio
codex mcp-server
```

Use that path when the ChatGPT workspace has custom MCP developer mode. OpenAI currently documents that capability for Business and Enterprise/Edu web workspaces, not Plus.

Upstream references:

- https://developers.openai.com/codex/mcp-server
- https://developers.openai.com/api/docs/guides/secure-mcp-tunnels
- https://github.com/openai/tunnel-client
