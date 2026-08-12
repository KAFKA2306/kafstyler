# ChatGPT ↔ Codex CLI Autonomous Bridge

## Purpose

ChatGPT からローカルの OpenAI Codex CLI にタスクを渡し、Codex の最終結果を ChatGPT が自律的に受け取って次の判断へ進めるための bridge。

現在の ChatGPT web はローカル Codex の `config.toml` を直接読み込まないため、private GitHub Issue queue をローカル実行への正準線として使う。

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
  │ ChatGPT condition watch / explicit verification
  ▼
ChatGPT verifies → next Codex task or user notification
```

## Components

- OpenAI Codex CLI: https://github.com/openai/codex
- GitHub CLI: https://cli.github.com/
- Queue: `KAFKA2306/basic_prompts` private Issue #1
- ChatGPT GitHub connector
- Optional local MCP adapters explicitly allowlisted by the bridge

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

Normal isolated task:

```md
<!-- codex-bridge:v1 role=controller task=<unique-task-id> -->

```json
{"cwd":"D:\\absolute\\repo","prompt":"Precise Codex task"}
```
```

An allowlisted local MCP is opt-in per task. For YouTube Music:

```json
{
  "cwd":"D:\\absolute\\repo",
  "mcp":["youtube_music"],
  "prompt":"Create the requested private playlist and return its YouTube Music URL."
}
```

Unknown MCP names are rejected. The bridge currently allowlists only `youtube_music`.

### Codex → ChatGPT

```md
<!-- codex-bridge:v1 role=worker task=<same-task-id> -->
```

The worker response includes:

- Codex exit code
- absolute `cwd`
- MCP names explicitly enabled for the task
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
- Windows Scheduled Task starts the supervisor at user logon;
- every run keeps `--ignore-user-config`, `--disable apps`, and `--disable plugins`;
- an explicitly requested allowlisted MCP is injected only through one-off `--config` overrides.

## Security boundary

- queue repository is private;
- GitHub authentication stays in the official GitHub CLI credential store;
- Codex authentication files and API keys are never copied into Issue comments;
- raw Codex JSONL stays on the local machine;
- user Codex config, apps, and plugins stay disabled for bridge runs;
- local MCPs are deny-by-default and opt-in per queue task;
- `youtube_music` requires its local OAuth token to exist before a bridge task can enable it;
- bridge posts only final text plus bounded execution/Git evidence;
- high-risk or irreversible follow-up actions remain subject to ChatGPT-side approval rules.

## Direct MCP path

OpenAI documents local MCP support for the ChatGPT desktop app, Codex CLI, and the Codex IDE extension on the same Codex host. ChatGPT web does not read local Codex configuration. For hosted web use, MCP-backed tools are supplied through installed plugins rather than the local `config.toml`.

Upstream references:

- https://learn.chatgpt.com/docs/extend/mcp?surface=cli
- https://learn.chatgpt.com/docs/config-file/config-advanced
- https://github.com/openai/codex
