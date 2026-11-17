"""共通フックと、全Markdownへのスキル適用記録を確かめる。"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


REVIEW_PATH = Path("hooks/markdown-reviews.json")
SHARED_RULES = ("AGENTS.md", "BIBLES.md", "MISSION.md")
MARKDOWN_SUFFIXES = {
    ".md", ".livemd", ".markdown", ".mdown", ".mdwn", ".mdx", ".mkd", ".mkdn",
    ".mkdown", ".ronn", ".scd", ".workbook",
}


def read_markdown_input(root, path, staged):
    if staged:
        content = subprocess.check_output(["git", "show", f":{path.as_posix()}"], cwd=root)
        return content.decode("utf-8").replace("\r\n", "\n").replace("\r", "\n")
    candidate = root / path
    if not candidate.is_file() or not candidate.resolve().is_relative_to(root):
        raise ValueError(f"リポジトリ内のファイルを読めない。{path}")
    return candidate.read_text(encoding="utf-8")


def markdown_inventory(root, staged):
    args = ["git", "ls-files", "--cached", "--full-name", "-z"]
    if not staged:
        args.extend(("--others", "--exclude-standard"))
    output = subprocess.check_output(args, cwd=root)
    documents = {}
    skills = {}
    for name in sorted(set(os.fsdecode(output).split("\0"))):
        path = Path(name)
        if path.suffix.lower() not in MARKDOWN_SUFFIXES and path.name != "contents.lr":
            continue
        if not staged and not (root / path).exists():
            continue
        content = read_markdown_input(root, path, staged)
        documents[name] = hashlib.sha256(content.encode("utf-8")).hexdigest()
        if path.match("skills/*/SKILL.md") and len(path.parts) == 3:
            skills[path.parent.name] = documents[name]

    if not skills:
        raise ValueError("監査する skills/*/SKILL.md がない。")
    definitions = {"共通規約": {name: documents[name] for name in SHARED_RULES}, "スキル": skills}
    rules = hashlib.sha256(json.dumps(definitions, sort_keys=True).encode("utf-8")).hexdigest()
    return {"rules": rules, "skills": sorted(skills), "documents": documents}


def unique_fields(pairs):
    fields = {}
    for key, value in pairs:
        if key in fields:
            raise ValueError(f"適用記録に同じキーがある。{key}")
        fields[key] = value
    return fields


def check_markdown(root, inventory, staged):
    review = json.loads(read_markdown_input(root, REVIEW_PATH, staged), object_pairs_hook=unique_fields)
    documents = review["documents"]
    if not isinstance(documents, dict):
        raise ValueError("適用記録の documents は文書パスをキーにしたオブジェクトにする。")
    skills = set(inventory["skills"])
    errors = []
    if review.get("rules") != inventory["rules"]:
        errors.append("規約またはスキルが変わった。現行版で全Markdownを確認する。")
    for path, digest in inventory["documents"].items():
        entry = documents.get(path, {})
        if not isinstance(entry, dict) or not isinstance(entry.get("results", {}), dict):
            errors.append(f"{path} の適用記録の形式が違う。")
            continue
        results = entry.get("results", {})
        if path not in documents:
            errors.append(f"{path} に全スキルの適用記録がない。")
            continue
        if entry.get("sha256") != digest:
            errors.append(f"{path} が変わった。現行版で全スキルを使う。")
        for skill in sorted(skills - results.keys()):
            errors.append(f"{path} に {skill} の適用記録がない。")
        for skill, result in results.items():
            if skill not in skills:
                errors.append(f"{path} に存在しないスキル {skill} の記録がある。")
                continue
            if (not isinstance(result, dict) or result.get("status") != "pass"
                    or not isinstance(result.get("evidence"), str) or not result["evidence"].strip()):
                errors.append(f"{path} の {skill} に根拠のある合格記録がない。")

    for path in sorted(documents.keys() - inventory["documents"].keys()):
        errors.append(f"存在しないMarkdown {path} の適用記録がある。")
    for error in errors:
        print(f"Markdown 不合格 {error}")
    if errors:
        return False
    count = len(documents)
    print(f"Markdown 合格 {count}文書 × {len(skills)}スキル = {count * len(skills)}件の適用記録")
    return True


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
    expected_skills = set(re.findall(r"\]\(skills/([^/\s()]+)/SKILL\.md[)#]", policy))
    packaged_skills = {path.parent.name for path in (root / "skills").glob("*/SKILL.md")}
    if expected_skills != packaged_skills:
        missing = ", ".join(sorted(expected_skills - packaged_skills)) or "なし"
        unlisted = ", ".join(sorted(packaged_skills - expected_skills)) or "なし"
        raise ValueError(f"作業規約と配布スキルが一致しない（配布漏れ {missing}、規約への記載漏れ {unlisted}）。")
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
        "提出前に実行結果と完了条件の照合を促す": (
            stop_continues and "kafstyler:scrutiny" in review_context
            and "実行結果、根拠を照合" in review_context
            and "完了扱いにしない" in review_context
            and "python3 hooks/check.py" in review_context
        ),
        "本体の依頼受付で全Markdownへの適用を案内し、提出前に版と記録を照合する": (
            "--markdown-inventory" in prompt and "全スキル" in prompt
            and "本体のMarkdown適用記録の照合結果" in review_context
        ),
        "依頼受付・委譲・提出前に全スキルの発動条件が届く": all_routes_delivered,
        "提出前の確認は一度で止まる": resumed == {},
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--markdown-inventory", action="store_true", help="文書とスキルの現行版を出力する")
    modes.add_argument("--markdown-only", action="store_true", help="Markdownの適用記録だけを照合する")
    modes.add_argument("--staged", action="store_true", help="コミット対象のMarkdownと適用記録を照合する")
    args = parser.parse_args()
    root = Path.cwd()
    try:
        inventory = markdown_inventory(root, args.staged)
        if args.markdown_inventory:
            print(json.dumps(inventory, ensure_ascii=False, indent=2))
            sys.exit(0)
        passed = check_markdown(root, inventory, args.staged)
    except (AttributeError, KeyError, OSError, TypeError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Markdown 不合格 {error}")
        passed = False
    if args.markdown_only or args.markdown_inventory or args.staged:
        sys.exit(0 if passed else 1)
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
