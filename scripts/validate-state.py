#!/usr/bin/env python3
"""Validate one Kafstyler handoff state JSON without modifying it."""
import argparse
import json
import re
import sys
from pathlib import Path

FIELDS = frozenset({
    "job_key", "target_commit", "status", "verify_cmd",
    "static_pass", "live_entry_verified",
})
STATUSES = frozenset({"done", "stopped", "blocked", "noop"})
COMMIT_SHA = re.compile(r"(?:[0-9a-fA-F]{40}|[0-9a-fA-F]{64})\Z")


def check(value):
    if not isinstance(value, dict):
        return "root: expected a JSON object"
    if set(value) != FIELDS:
        return "fields: missing=" + ",".join(sorted(FIELDS - set(value))) + "; unexpected=" + ",".join(sorted(set(value) - FIELDS))
    if not isinstance(value["job_key"], str) or not value["job_key"].strip():
        return "job_key: expected a nonempty string"
    if not isinstance(value["status"], str) or value["status"] not in STATUSES:
        return "status: expected done, stopped, blocked, or noop"
    target = value["target_commit"]
    if target is None:
        if value["status"] not in ("blocked", "stopped"):
            return "target_commit: unknown target cannot be done/noop"
    elif target != "not_applicable" and (not isinstance(target, str) or not COMMIT_SHA.fullmatch(target)):
        return "target_commit: expected a full Git commit SHA, not_applicable, or null for stopped/blocked"
    if not isinstance(value["verify_cmd"], str):
        return "verify_cmd: expected a string (empty if not run)"
    for key in ("static_pass", "live_entry_verified"):
        if value[key] is not None and type(value[key]) is not bool and value[key] != "not_applicable":
            return f"{key}: expected true, false, null (unverified), or not_applicable"
    if value["status"] in ("done", "noop"):
        results = (value["static_pass"], value["live_entry_verified"])
        if any(result is not True and result != "not_applicable" for result in results):
            return "status: done/noop cannot contain failed or unverified checks"
        if not any(result is True for result in results):
            return "status: done/noop requires at least one passed check"
        if value["static_pass"] is True and not value["verify_cmd"].strip():
            return "verify_cmd: passed static check requires a nonempty verification command"
        if value["status"] == "done" and value["live_entry_verified"] is not True:
            return "status: done requires live_entry_verified=true"
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("json_file", help="Path to one state JSON object, or - for stdin")
    args = parser.parse_args()
    try:
        source = sys.stdin.read() if args.json_file == "-" else Path(args.json_file).read_text(encoding="utf-8")
        value = json.loads(source)
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        print(f"FAIL: input: {error}", file=sys.stderr)
        return 1
    error = check(value)
    if error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
