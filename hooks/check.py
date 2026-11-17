"""両クライアントのマニフェストから共通フックを起動して確かめる。"""

import json
import os
from pathlib import Path
import subprocess
import sys


def run_hook(root, hooks, host, event, **fields):
    payload = {"hook_event_name": event, "cwd": str(root), **fields}
    env = {**os.environ, "CLAUDE_PLUGIN_ROOT": str(root)}
    env.pop("PLUGIN_ROOT", None)
    if host == "codex":
        env["PLUGIN_ROOT"] = str(root)
    output = []
    for matcher in hooks[event]:
        for handler in matcher["hooks"]:
            result = subprocess.run(
                ["bash", "-c", handler["command"]],
                input=json.dumps(payload),
                text=True,
                capture_output=True,
                cwd=root,
                env=env,
                timeout=handler["timeout"],
            )
            if result.returncode:
                raise ValueError(f"{event} が終了コード {result.returncode} で失敗した。{result.stderr}")
            output.append(result.stdout)
    return "".join(output)


def check(root, host):
    manifest = json.loads((root / f".{host}-plugin/plugin.json").read_text(encoding="utf-8"))
    hooks = manifest["hooks"] if host == "claude" else manifest["hooks"]["hooks"]
    policy = (root / "AGENTS.md").read_text(encoding="utf-8").rstrip("\n")
    session = run_hook(root, hooks, host, "SessionStart", source="startup")
    delegated = json.loads(run_hook(root, hooks, host, "SubagentStart", agent_type="general-purpose"))
    prompt = run_hook(root, hooks, host, "UserPromptSubmit", prompt="READMEの起動手順を確かめて")
    stop = json.loads(run_hook(root, hooks, host, "Stop", stop_hook_active=False))
    resumed = json.loads(run_hook(root, hooks, host, "Stop", stop_hook_active=True))

    child_context = delegated["hookSpecificOutput"]
    if host == "claude":
        review = stop["hookSpecificOutput"]
        stop_continues = review["hookEventName"] == "Stop"
        review_context = review["additionalContext"]
    else:
        stop_continues = stop["decision"] == "block"
        review_context = stop["reason"]

    return {
        "セッションに対象版の規約が届く": policy in session and str(root / "AGENTS.md") in session,
        "委譲先に同じ規約が届く": (
            child_context["hookEventName"] == "SubagentStart"
            and policy in child_context["additionalContext"]
        ),
        "依頼受付で対象版と目標設定が示される": (
            f"使用中のKafstylerの場所は {root}。" in prompt and "kafstyler:charter" in prompt
        ),
        "提出前に反証レビューと本体の検証が指示される": (
            stop_continues and "kafstyler:scrutiny" in review_context
            and "python3 hooks/check.py" in review_context
        ),
        "提出前の確認は一度で止まる": resumed == {},
    }


if __name__ == "__main__":
    root = Path.cwd()
    passed = True
    for host in ("claude", "codex"):
        try:
            results = check(root, host)
        except (KeyError, OSError, ValueError, subprocess.TimeoutExpired) as error:
            print(f"{host} 不合格 {error}", file=sys.stderr)
            passed = False
            continue
        for description, ok in results.items():
            print(f"{host} {'合格' if ok else '不合格'} {description}")
        passed = passed and all(results.values())
    sys.exit(0 if passed else 1)
