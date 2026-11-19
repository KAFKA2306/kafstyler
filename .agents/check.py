"""共通フックと、全Markdownへのスキル適用記録を確かめる。"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys


REVIEW_PATH = Path(".agents/markdown-reviews.json")
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


def inventory_paths(root, staged, all_files):
    args = ["git", "ls-files", "--cached", "--full-name", "-z"]
    if not staged and not all_files:
        args.extend(("--others", "--exclude-standard"))
    output = subprocess.check_output(args, cwd=root)
    return sorted(set(os.fsdecode(output).split("\0")) - {""})


def file_digest(root, path, staged):
    if staged:
        content = subprocess.check_output(["git", "show", f":{path.as_posix()}"], cwd=root)
    else:
        candidate = root / path
        if not candidate.is_file() or not candidate.resolve().is_relative_to(root):
            raise ValueError(f"リポジトリ内のファイルを読めない。{path}")
        content = candidate.read_bytes()
    if path == REVIEW_PATH:
        review = json.loads(content, object_pairs_hook=unique_fields)
        # 台帳の自己参照を除き、他の結果や版が変われば要約値も変わるようにする。
        review.get("files", {}).get(path.as_posix(), {}).pop("sha256", None)
        content = json.dumps(review, ensure_ascii=False, sort_keys=True).encode("utf-8")
    return hashlib.sha256(content).hexdigest()


def markdown_inventory(root, staged, all_files=False):
    documents = {}
    files = {}
    skills = {}
    for name in inventory_paths(root, staged, all_files):
        path = Path(name)
        if not staged and not (root / path).exists():
            if all_files:
                raise ValueError(f"追跡中のファイルが作業ツリーにない。{path}")
            continue
        if path.suffix.lower() not in MARKDOWN_SUFFIXES and path.name != "contents.lr":
            if all_files:
                files[name] = file_digest(root, path, staged)
            continue
        content = read_markdown_input(root, path, staged)
        documents[name] = hashlib.sha256(content.encode("utf-8")).hexdigest()
        if path.match("skills/*/SKILL.md") and len(path.parts) == 3:
            skills[path.parent.name] = documents[name]

    if not skills:
        raise ValueError("監査する skills/*/SKILL.md がない。")
    definitions = {"共通規約": {name: documents[name] for name in SHARED_RULES}, "スキル": skills}
    rules = hashlib.sha256(json.dumps(definitions, sort_keys=True).encode("utf-8")).hexdigest()
    inventory = {"rules": rules, "skills": sorted(skills), "documents": documents}
    if all_files:
        inventory["files"] = files
    return inventory


def unique_fields(pairs):
    fields = {}
    for key, value in pairs:
        if key in fields:
            raise ValueError(f"適用記録に同じキーがある。{key}")
        fields[key] = value
    return fields


def check_markdown(root, inventory, staged):
    review = json.loads(read_markdown_input(root, REVIEW_PATH, staged), object_pairs_hook=unique_fields)
    skills = set(inventory["skills"])
    errors = []
    if review.get("rules") != inventory["rules"]:
        errors.append("規約またはスキルが変わった。現行版で対象を確認する。")
    counts = dict.fromkeys(("pass", "fail", "not_applicable", "pending"), 0)
    for group in ("documents", "files"):
        if group in inventory:
            check_review_entries(review.get(group), inventory[group], skills, counts, errors)
    label = "全ファイル" if "files" in inventory else "Markdown"
    for error in errors:
        print(f"{label} 不合格 {error}")
    count = len(inventory["documents"]) + len(inventory.get("files", {}))
    print(
        f"{label} {'不合格' if errors else '合格'} {count}件 × {len(skills)}スキル。"
        f"合格 {counts['pass']}、不合格 {counts['fail']}、"
        f"適用外 {counts['not_applicable']}、未確認 {counts['pending']}。"
    )
    return not errors


def check_review_entries(documents, inventory, skills, counts, errors):
    if not isinstance(documents, dict):
        raise ValueError("適用記録はファイルパスをキーにしたオブジェクトにする。")
    for path, digest in inventory.items():
        entry = documents.get(path, {})
        if not isinstance(entry, dict) or not isinstance(entry.get("results", {}), dict):
            errors.append(f"{path} の適用記録の形式が違う。")
            continue
        results = entry.get("results", {})
        if path not in documents:
            errors.append(f"{path} に全スキルの適用記録がない。")
            continue
        if entry.get("sha256") != digest:
            errors.append(f"{path} が変わった。現行版で適用結果を確認する。")
        for skill in sorted(skills - results.keys()):
            errors.append(f"{path} に {skill} の適用記録がない。")
        for skill, result in results.items():
            if skill not in skills:
                errors.append(f"{path} に存在しないスキル {skill} の記録がある。")
                continue
            if not isinstance(result, dict):
                errors.append(f"{path} の {skill} の適用結果がオブジェクトではない。")
                continue
            status = result.get("status")
            evidence = result.get("evidence")
            if not isinstance(status, str) or status not in counts:
                errors.append(f"{path} の {skill} に不明な適用状態 {status!r} がある。")
                continue
            if not isinstance(evidence, str) or not evidence.strip():
                errors.append(f"{path} の {skill} に判断の根拠がない。")
                continue
            if status == "pending":
                errors.append(f"{path} の {skill} は未確認: {evidence}")
            elif status == "fail":
                errors.append(f"{path} の {skill} は不合格: {evidence}")
            elif status == "pass" and re.search(
                r"(?:は|が|で)\s*(?:未確認|未検証|未実施)(?=[\s。、．]|$)"
                r"|(?:実行|実施|検証|確認|試験|導入)していない|試していない|確かめていない",
                evidence,
            ):
                errors.append(f"{path} の {skill} は未確認事項を含むため合格の範囲を再評価する。")
                continue
            counts[status] += 1
    for path in sorted(documents.keys() - inventory.keys()):
        errors.append(f"対象に存在しないファイル {path} の適用記録がある。")


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
    prompt = run_hook(root, hooks, host, "UserPromptSubmit", prompt="READMEの起動手順を確かめて")
    skill_routes = re.findall(r"^- kafstyler:([^\s]+) — .+$", prompt, flags=re.MULTILINE)

    return {
        "配布フックは起動時と依頼受付の2件": set(hooks) == {"SessionStart", "UserPromptSubmit"},
        "セッションに対象版の規約が届く": policy in session and str(root / "AGENTS.md") in session,
        "依頼受付で対象版と設計前の目標設定・評価が示される": (
            f"使用中のKafstylerの場所は {root}。" in prompt
            and "着手前に kafstyler:charter" in prompt
            and "kafstyler:benchmark で自動判定方法を固定してから設計する。" in prompt
        ),
        "依頼受付で全スキルの発動条件が一つずつ届く": (
            bool(expected_skills) and sorted(skill_routes) == sorted(expected_skills)
        ),
        "本体の依頼受付で全Markdownへの適用と記録を案内する": (
            "--markdown-inventory" in prompt and "全スキル" in prompt and "結果を記録する" in prompt
        ),
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--markdown-inventory", action="store_true", help="文書とスキルの現行版を出力する")
    modes.add_argument("--markdown-only", action="store_true", help="Markdownの適用記録だけを照合する")
    modes.add_argument("--staged", action="store_true", help="コミットに含める版と適用記録を照合する")
    parser.add_argument("--all-files", action="store_true", help="Gitで追跡する全ファイルを対象にする")
    args = parser.parse_args()
    root = Path.cwd()
    try:
        inventory = markdown_inventory(root, args.staged, args.all_files)
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
