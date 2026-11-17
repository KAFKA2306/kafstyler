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

    expected_skills = {path.parent.name for path in (root / "skills").glob("*/SKILL.md")}
    contexts = (prompt, child_context["additionalContext"], review_context)
    all_routes_delivered = bool(expected_skills) and all(
        {line.split()[1].removeprefix("kafstyler:") for line in context.splitlines()
         if line.startswith("- kafstyler:")} == expected_skills
        for context in contexts
    )

    return {
        "セッションに対象版の規約が届く": policy in session and str(root / "AGENTS.md") in session,
        "委譲先に同じ規約が届く": (
            child_context["hookEventName"] == "SubagentStart"
            and policy in child_context["additionalContext"]
        ),
        "依頼受付で対象版と目標設定が示される": (
            f"使用中のKafstylerの場所は {root}。" in prompt and "kafstyler:charter" in prompt
        ),
        "提出前に必須スキルの実行結果と完了条件が照合される": (
            stop_continues and "kafstyler:scrutiny" in review_context
            and "実行結果、根拠を照合" in review_context
            and "完了扱いにしない" in review_context
            and "python3 hooks/check.py" in review_context
        ),
        "依頼受付・委譲・提出前に全スキルの発動条件が届く": all_routes_delivered,
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
