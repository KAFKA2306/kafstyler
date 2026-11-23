#!/usr/bin/env python3
"""Read-only Git checkout gate for Orca workers that write through Kafstyler."""

import argparse
import json
import os
from pathlib import Path
import subprocess
import sys


class GitError(Exception):
    pass


def git(root: Path, *args: str) -> str:
    env = os.environ.copy()
    env["GIT_OPTIONAL_LOCKS"] = "0"
    result = subprocess.run(
        ["git", "-C", str(root), *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        env=env,
        check=False,
    )
    if result.returncode:
        detail = result.stderr.strip() or result.stdout.strip()
        raise GitError(f"git {' '.join(args)} failed ({result.returncode}): {detail}")
    return result.stdout.strip()


def inspect(root: Path) -> dict:
    checkout = Path(git(root, "rev-parse", "--show-toplevel")).resolve()
    branch = git(root, "branch", "--show-current")
    head = git(root, "rev-parse", "HEAD")
    worktrees = [line for line in git(root, "worktree", "list", "--porcelain").splitlines() if line.startswith("worktree ")]
    branches = git(root, "branch", "--format=%(refname:short)").splitlines()
    dirty = git(root, "status", "--porcelain=v1", "-uall")
    stashes = git(root, "stash", "list")
    problems = []
    if branch != "main":
        problems.append(f"current branch is {branch!r}, expected 'main'")
    if len(worktrees) != 1:
        problems.append(f"expected one worktree, found {len(worktrees)}")
    if branches != ["main"]:
        problems.append(f"expected only local main branch, found {branches!r}")
    if dirty:
        problems.append("checkout contains staged, unstaged, or untracked changes")
    if stashes:
        problems.append("stash entries need review")
    return {
        "status": "ready" if not problems else "blocked",
        "checkout": str(checkout),
        "branch": branch,
        "head": head,
        "worktree_count": len(worktrees),
        "local_branches": branches,
        "clean": not bool(dirty),
        "stash_empty": not bool(stashes),
        "reasons": problems,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="Target Git checkout")
    args = parser.parse_args(argv)
    try:
        result = inspect(args.repo.resolve())
    except (GitError, OSError) as exc:
        print(json.dumps({"status": "error", "reasons": [str(exc)]}, ensure_ascii=False))
        return 1
    print(json.dumps(result, ensure_ascii=False))
    return 0 if result["status"] == "ready" else 2


if __name__ == "__main__":
    sys.exit(main())
