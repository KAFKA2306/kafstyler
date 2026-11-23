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
    if not isinstance(value["target_commit"], str) or not COMMIT_SHA.fullmatch(value["target_commit"]):
        return "target_commit: expected a full Git commit SHA"
    if not isinstance(value["status"], str) or value["status"] not in STATUSES:
        return "status: expected done, stopped, blocked, or noop"
    if not isinstance(value["verify_cmd"], str):
        return "verify_cmd: expected a string (empty if not run)"
    for key in ("static_pass", "live_entry_verified"):
        if value[key] is not None and type(value[key]) is not bool:
            return f"{key}: expected true, false, or null (unverified)"
    if value["status"] == "done":
        if not value["verify_cmd"].strip():
            return "verify_cmd: done requires a nonempty verification command"
        if value["static_pass"] is not True or value["live_entry_verified"] is not True:
            return "status: done requires static_pass=true and live_entry_verified=true"
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
