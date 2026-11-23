#!/usr/bin/env python3
"""Inspect VRC Friend Connect's SQLite schema only when VR software is idle.

Does not read friend rows, notes, config, tokens, or log contents; does not
start models, call VRChat APIs, or modify the application's files.
"""
import argparse
import csv
from contextlib import closing
import io
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import sys
import urllib.request
from urllib.parse import urlsplit

BUSY_NAMES = {
    "vrchat.exe", "vrserver.exe", "vrcompositor.exe", "vrmonitor.exe",
    "vrc friend connect.exe",
}
DB_NAMES = ("db_1.1.sqlite", "db.sqlite")


class ProbeError(RuntimeError):
    pass


def busy_processes():
    try:
        result = subprocess.run(
            ["tasklist.exe", "/FO", "CSV", "/NH"], capture_output=True,
            timeout=5, check=True,
        )
    except (OSError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as exc:
        raise ProbeError("Windows tasklist unavailable; VR idle state unknown") from exc
    names = set()
    for row in csv.reader(io.StringIO(result.stdout.decode("utf-8", errors="replace"))):
        if row and row[0].lower().endswith(".exe"):
            names.add(row[0].casefold())
    if not names:
        raise ProbeError("tasklist returned no process entries; inspection refused")
    return sorted(names & BUSY_NAMES)


def require_idle():
    return busy_processes()


def database_metadata(path):
    uri = path.resolve().as_uri() + "?mode=ro"
    with closing(sqlite3.connect(uri, uri=True, timeout=0.05)) as db:
        db.execute("PRAGMA query_only=ON")
        db.execute("PRAGMA busy_timeout=50")
        version = db.execute("PRAGMA user_version").fetchone()[0]
        rows = db.execute(
            "SELECT name FROM sqlite_master WHERE type='table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name LIMIT 101"
        ).fetchall()
        if len(rows) > 100:
            raise ProbeError(f"Unexpected number of tables in {path.name}")
        tables = []
        for (name,) in rows:
            quoted = name.replace('"', '""')
            columns = db.execute(f'PRAGMA table_info("{quoted}")').fetchall()
            tables.append({"table": name, "columns": [column[1] for column in columns]})
        return {"file": path.name, "user_version": version, "tables": tables}


def label_schema(report, endpoint):
    parsed = urlsplit(endpoint)
    if (
        parsed.scheme != "http"
        or parsed.hostname not in {"127.0.0.1", "::1"}
        or parsed.username or parsed.password or parsed.query or parsed.fragment
        or parsed.path != "/v1/systemone"
    ):
        raise ProbeError("d1 endpoint must be loopback HTTP /v1/systemone")
    questions = {}
    for database in report["databases"]:
        for table in database["tables"]:
            key = f"table_{len(questions)}"
            if len(questions) >= 16:
                raise ProbeError("Too many tables for bounded d1 classification")
            questions[key] = {
                "type": "choice",
                "instructions": (
                    f"What is the likely purpose of table "
                    f"{database['file']}::{table['table']}?"
                ),
                "criteria": {
                    "encounter": "VRChat meetings, co-presence or visited instances",
                    "friend": "VRChat friend profiles or friendship data",
                    "internal": "Application configuration, cache or migrations",
                    "unknown": "Not enough evidence from table and column names",
                },
            }
    if not questions:
        return None
    payload = json.dumps(
        {"state": report["databases"], "questions": questions},
        ensure_ascii=False,
    ).encode()
    request = urllib.request.Request(
        endpoint, data=payload, headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
        with opener.open(request, timeout=3) as response:
            raw = response.read(1_000_001)
            if len(raw) > 1_000_000:
                raise ProbeError("Local d1 response exceeded 1 MB")
            result = json.loads(raw)
    except (OSError, ValueError) as exc:
        raise ProbeError("Local d1 endpoint failed; no automatic fallback") from exc
    if not isinstance(result, dict) or not isinstance(result.get("answers"), dict):
        raise ProbeError("Local d1 returned an invalid response")
    return result["answers"]


def probe(root, endpoint=None):
    active = require_idle()
    if active:
        return {"status": "skipped", "reason": "VR activity present", "processes": active}
    dbdir = root / "db"
    paths = [dbdir / name for name in DB_NAMES if (dbdir / name).is_file()]
    if not paths:
        raise ProbeError("No documented VRC Friend Connect SQLite database found")
    report = {
        "status": "schema_only",
        "source": "VRC Friend Connect",
        "databases": [database_metadata(path) for path in paths],
        "rows_exported": 0,
    }
    if require_idle():
        return {"status": "skipped", "reason": "VR activity began during inspection"}
    if endpoint:
        report["schema_hints_unverified"] = label_schema(report, endpoint)
        if require_idle():
            return {"status": "skipped", "reason": "VR activity began during classification"}
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, help="VRC Friend Connect data root")
    parser.add_argument("--d1-endpoint", help="Optional existing loopback /v1/systemone")
    args = parser.parse_args()
    root = args.root
    if root is None:
        appdata = os.environ.get("APPDATA")
        if not appdata:
            parser.error("APPDATA not set; pass --root explicitly (e.g. in WSL)")
        root = Path(appdata) / "VRC Friend Connect"
    try:
        result = probe(root, args.d1_endpoint)
    except (ProbeError, sqlite3.Error) as exc:
        print(f"vrcfriend: {exc}", file=sys.stderr)
        return 2
    print(json.dumps(result, ensure_ascii=False, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
