# ChatGPT ↔ Codex App Server Bridge v2

ChatGPT を controller、ローカル Codex を Windows / Unity 実行 worker として接続するための private bridge。

## Canonical architecture

```text
ChatGPT
  │ GitHub connector: v2 controller task
  ▼
private GitHub Issue #3
  │ incremental queue fetch
  ▼
thin Windows bridge
  │ one long-lived stdio child process
  ▼
codex app-server
  │ thread/start (ephemeral) → turn/start → turn/completed
  │ normal Codex config.toml / MCP configuration
  ▼
configured MCP servers (Unity MCP etc.)
  ▼
one worker/status comment updated in place
  ▼
ChatGPT verifies evidence and decides the next step
```

This deliberately does **not** run `codex exec --ignore-user-config`. The bridge starts `codex app-server --stdio` without disabling the user's normal Codex configuration layers, then asks App Server for the configured MCP server list before a task that declares `required_mcp_servers`.

OpenAI documents `codex app-server` as the interface used for rich Codex clients such as the VS Code extension. Its stdio transport is newline-delimited JSON, the connection must be initialized once, and the normal lifecycle is `thread/start` → `turn/start` → streamed events → `turn/completed`.

Official upstream:

- Codex App Server: https://github.com/openai/codex/blob/main/codex-rs/app-server/README.md
- OpenAI Codex repository: https://github.com/openai/codex
- ChatGPT developer mode / MCP apps: https://help.openai.com/en/articles/12584461
- Apps in ChatGPT: https://help.openai.com/en/articles/11487775-connectors-in

## Why v2 replaced v1

v1 proved this path:

```text
ChatGPT → GitHub → Windows daemon → Codex → GitHub
```

It also proved that Codex could reach `D:\3d\unity\project\avatars2509`.

But v1 launched a fresh process per task with:

```text
codex exec --ignore-user-config --disable apps --disable plugins ...
```

That made it the wrong transport for tasks whose purpose is to use MCP servers from the normal Codex configuration. A successful `BRIDGE_OK` only proved the transport loop; it did not prove `Codex → Unity MCP → Unity`.

v2 removes that architecture rather than adding more one-off MCP injection logic.

## Task state machine

```text
QUEUED
  ↓
CLAIMED
  ↓
RUNNING
  ├─→ SUCCEEDED
  ├─→ FAILED
  └─→ BLOCKED
```

`SUCCEEDED` means the App Server turn completed. It is **not** an automatic claim that the higher-level problem is solved. ChatGPT reviews the final message, MCP/tool evidence, and Git evidence before deciding the next task or completion.

Each task gets one worker/status comment. The bridge updates that same comment from `CLAIMED` to `RUNNING` to the terminal state, rather than appending a new comment for every transition.

## Controller protocol

````md
<!-- codex-bridge:v2 role=controller task=<unique-id> -->

```json
{
  "cwd": "D:\\absolute\\repo",
  "prompt": "Exact execution task",
  "mode": "execute_only",
  "required_mcp_servers": ["unityMCP"],
  "allowed_paths": ["D:\\absolute\\repo\\Assets"],
  "allow_commit": false,
  "allow_push": false,
  "allow_network": false,
  "allow_unity_save": false,
  "allow_reimport": false
}
```
````

Rules:

- `cwd` and `prompt` are required.
- `mode` is currently fixed to `execute_only`.
- `required_mcp_servers` must match names already configured in normal Codex configuration. The bridge does not synthesize per-task MCP definitions.
- `allowed_paths` are existing writable directory roots and must remain under `cwd`.
- all permission-like flags default to `false`.
- `allow_commit=true` or `allow_push=true` enables local workspace-write; if no narrower `allowed_paths` are declared, the writable root becomes `cwd`.
- `allow_push=true` requires `allow_network=true`.
- `allow_network` means **Codex local shell network access**, not the network behavior of an external MCP server.
- stable v2 does not invent a read-only+network legacy sandbox shape. Therefore `allow_network=true` is rejected unless local workspace-write is also explicitly enabled.
- `allow_unity_save` and `allow_reimport` authorize only those Unity-side effects in the execution-worker contract. They do **not** widen the Codex local shell/filesystem sandbox.
- when no local write capability is requested, the turn uses a `readOnly` sandbox policy.
- when local writes are requested, the turn uses `workspaceWrite` with the declared writable roots and requested shell-network policy.
- approval policy is `never`; the bridge has no interactive approval UI.
- known App Server MCP elicitations are explicitly declined, permission-escalation requests receive an empty granted permission set, and unknown server-initiated requests fail closed.
- pre-existing dirty worktrees are never cleaned or reset.

### Permission boundary

The system has two distinct side-effect domains and v2 intentionally keeps them separate:

```text
Codex shell / filesystem
  └─ sandboxPolicy: readOnly | workspaceWrite

Configured MCP server (for example Unity MCP)
  └─ external tool process with its own behavior + bridge worker contract
```

A Codex filesystem sandbox cannot by itself prove that an external MCP server is read-only. For that reason the bridge never describes `allow_unity_save` or `allow_reimport` as sandbox guarantees. They are explicit controller authorizations passed into the execution-only contract, while App Server MCP/tool events are retained as evidence for ChatGPT review.

If an MCP server asks the App Server client for interactive structured input or tool approval through `mcpServer/elicitation/request`, this non-interactive bridge returns `decline`. If the built-in permission tool requests more filesystem/network permissions, v2 grants none.

## Worker evidence

The terminal status payload includes bounded evidence:

- `cwd`
- App Server PID
- App Server thread / turn ids
- turn status and error
- required and configured MCP server names
- observed MCP startup status
- command / file-change / MCP-tool operation summaries from App Server items
- App Server warnings
- Git branch / HEAD / diff stat / bounded porcelain status before and after
- final Codex agent message

Raw reasoning is not copied to GitHub.

For tasks with no local write and no Unity save/reimport authorization, the bridge also compares before/after Git HEAD and status. Any change makes the task fail.

## App Server lifecycle

The daemon starts one long-lived:

```powershell
codex app-server --stdio
```

It performs the required `initialize` → `initialized` handshake once per process.

For every task it:

1. calls `config/mcpServer/reload`;
2. calls `mcpServerStatus/list` and checks every requested MCP server name;
3. starts a fresh **ephemeral** thread with `thread/start`;
4. checks MCP visibility again in that thread;
5. starts the turn with `turn/start`;
6. consumes item / MCP-startup events;
7. waits for `turn/completed`;
8. updates the existing GitHub worker comment.

Ephemeral threads avoid leaving rollout files for bridge jobs while retaining the App Server process and normal Codex config/MCP behavior.

If the bridge itself dies while a task is active, the supervisor restarts it. On startup, the interrupted task is marked `BLOCKED` and is **not replayed automatically**, avoiding duplicate side effects.

## Queue behavior

The v2 queue is:

- `KAFKA2306/kafstyler` private Issue #3
- https://github.com/KAFKA2306/kafstyler/issues/3

The daemon no longer reloads the entire historical comment stream on every poll. It fetches comments incrementally using `since`, with a small overlap and `last_comment_id` deduplication.

## Install / migrate on Windows

Prerequisites:

```powershell
codex --version
codex app-server --help
gh --version
gh auth status
```

Clone the current private repository and run:

```powershell
$dst = Join-Path $env:TEMP 'kafstyler-codex-bridge-v2'
Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue
gh repo clone KAFKA2306/kafstyler $dst
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$dst\codex-chatgpt-bridge\install.ps1"
```

The installer intentionally migrates destructively inside the bridge's own runtime directory only:

1. verifies `gh`, authentication, Codex, and `codex app-server`;
2. verifies access to private v2 queue Issue #3;
3. stops the existing scheduled task;
4. deletes `%LOCALAPPDATA%\OpenAI\CodexChatGPTBridge` so v1 daemon/state/log/task/smoke remnants do not survive;
5. copies only the v2 daemon and supervisor;
6. recreates the logon scheduled task;
7. starts v2 and requires App Server handshake evidence in `health.json`;
8. queues a disposable read-only `BRIDGE_V2_OK` smoke task.

The disposable smoke Git repository is removed by the daemon after its terminal status.

The installer does **not** delete or reset user repositories.

## Unity MCP E2E acceptance

Transport smoke alone is insufficient. v2 is considered fully proven for the Unity use case only after a controller task with `required_mcp_servers` set to the actual configured Unity MCP server name produces evidence of:

```text
ChatGPT
→ GitHub v2 queue
→ bridge v2
→ codex app-server
→ configured Unity MCP
→ Unity
→ turn/completed
→ GitHub terminal status
→ ChatGPT verification
```

The Unity probe should be read-only first. No Unity save/reimport is allowed until that probe succeeds.

## Direct MCP future path

OpenAI's current developer-mode documentation says full custom MCP/developer mode is available on ChatGPT Business and Enterprise/Edu web workspaces, while the broader Apps documentation notes that app availability can vary by plan, workspace, role, surface, and region. For that reason this repository does not assume that a direct custom MCP transport is guaranteed for the current account.

Where a supported ChatGPT custom MCP surface is available, local MCP is not connected directly; OpenAI documents Secure MCP Tunnel for MCP servers on a developer machine or private network. At that point the GitHub queue/Windows bridge can be retired in favor of the supported direct path.

Do not maintain a second local "codex-chatgpt-mcp" implementation in this repository. The direct path belongs in current upstream OpenAI onboarding, not in a parallel homemade bootstrap.
