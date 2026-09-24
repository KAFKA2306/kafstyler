#!/usr/bin/env python3
"""Compile and audit autonomous execution contracts using only the stdlib."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

DEFAULT_POLICY = Path(__file__).resolve().parents[1] / "policies" / "autonomy_contract.json"
COMPLETE_STATUSES = {"done", "pass"}


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as fh:
        data = json.load(fh)
    if not isinstance(data, dict):
        raise ValueError(f"Expected JSON object: {path}")
    return data


def load_policy(path: Path) -> dict[str, Any]:
    policy = load_json(path)
    profiles = policy.get("profiles")
    rules = policy.get("global_rules")
    if not isinstance(profiles, dict) or not profiles:
        raise ValueError("policy.profiles must be a non-empty object")
    if not isinstance(rules, list) or not rules:
        raise ValueError("policy.global_rules must be a non-empty array")
    for name, profile in profiles.items():
        gates = profile.get("gates") if isinstance(profile, dict) else None
        if not isinstance(gates, list) or not gates:
            raise ValueError(f"profile {name!r} must define non-empty gates")
        ids = [gate.get("id") for gate in gates if isinstance(gate, dict)]
        if len(ids) != len(set(ids)) or any(not gate_id for gate_id in ids):
            raise ValueError(f"profile {name!r} has missing/duplicate gate ids")
    return policy


def profile_for(policy: dict[str, Any], name: str) -> dict[str, Any]:
    try:
        return policy["profiles"][name]
    except KeyError as exc:
        choices = ", ".join(sorted(policy["profiles"]))
        raise ValueError(f"Unknown profile {name!r}. Choose one of: {choices}") from exc


def render_prompt(policy: dict[str, Any], profile_name: str, task: str | None) -> str:
    profile = profile_for(policy, profile_name)
    lines = [
        f"AUTONOMY CONTRACT v{policy.get('version', 1)}",
        f"Profile: {profile_name}",
    ]
    if task:
        lines.append(f"Task: {task}")
    lines.extend(["", "Global rules:"])
    for rule in policy["global_rules"]:
        lines.append(f"- [{rule['id']}] {rule['text']}")
    lines.extend(["", "Required execution gates:"])
    for index, gate in enumerate(profile["gates"], start=1):
        suffix = " Evidence required." if gate.get("evidence_required", True) else ""
        lines.append(f"{index}. [{gate['id']}] {gate['text']}{suffix}")
    lines.extend(
        [
            "",
            "Continue through reversible next steps without stopping for redundant confirmation.",
            "Do not report completion until all required gates pass with evidence where required.",
        ]
    )
    return "\n".join(lines)


def make_run(policy: dict[str, Any], profile_name: str, task: str | None) -> dict[str, Any]:
    profile = profile_for(policy, profile_name)
    return {
        "contract_version": policy.get("version", 1),
        "profile": profile_name,
        "task": task or "",
        "gates": {
            gate["id"]: {"status": "pending", "evidence": []}
            for gate in profile["gates"]
        },
        "notes": [],
    }


def audit_run(policy: dict[str, Any], run: dict[str, Any]) -> dict[str, Any]:
    profile_name = run.get("profile")
    if not isinstance(profile_name, str):
        raise ValueError("run.profile must be a string")
    profile = profile_for(policy, profile_name)
    gate_state = run.get("gates")
    if not isinstance(gate_state, dict):
        raise ValueError("run.gates must be an object")

    results: list[dict[str, Any]] = []
    for gate in profile["gates"]:
        state = gate_state.get(gate["id"], {})
        if not isinstance(state, dict):
            state = {}
        status = str(state.get("status", "pending")).lower()
        evidence = state.get("evidence", [])
        has_evidence = isinstance(evidence, list) and any(str(item).strip() for item in evidence)
        complete = status in COMPLETE_STATUSES
        reason = None
        if not complete:
            reason = f"status={status}"
        elif gate.get("evidence_required", True) and not has_evidence:
            complete = False
            reason = "missing evidence"
        results.append(
            {
                "id": gate["id"],
                "status": status,
                "complete": complete,
                "reason": reason,
            }
        )

    missing = [item for item in results if not item["complete"]]
    return {
        "profile": profile_name,
        "complete": not missing,
        "passed": len(results) - len(missing),
        "required": len(results),
        "missing": missing,
        "next_gate": missing[0]["id"] if missing else None,
        "results": results,
    }


def print_audit(report: dict[str, Any]) -> None:
    state = "COMPLETE" if report["complete"] else "INCOMPLETE"
    print(f"{state}: {report['passed']}/{report['required']} gates complete")
    if report["next_gate"]:
        print(f"NEXT: {report['next_gate']}")
    for item in report["missing"]:
        print(f"- {item['id']}: {item['reason']}")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--policy", type=Path, default=DEFAULT_POLICY)
    sub = parser.add_subparsers(dest="command", required=True)

    profiles = sub.add_parser("profiles", help="List available profiles")
    profiles.set_defaults(handler="profiles")

    prompt = sub.add_parser("prompt", help="Render a paste-ready agent execution contract")
    prompt.add_argument("--profile", required=True)
    prompt.add_argument("--task")
    prompt.set_defaults(handler="prompt")

    init_run = sub.add_parser("init-run", help="Create a machine-auditable run skeleton")
    init_run.add_argument("--profile", required=True)
    init_run.add_argument("--task")
    init_run.set_defaults(handler="init-run")

    audit = sub.add_parser("audit", help="Audit a run JSON file")
    audit.add_argument("run", type=Path)
    audit.add_argument("--json", action="store_true", dest="as_json")
    audit.set_defaults(handler="audit")

    nxt = sub.add_parser("next", help="Print the first incomplete gate")
    nxt.add_argument("run", type=Path)
    nxt.set_defaults(handler="next")

    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        policy = load_policy(args.policy)
        if args.handler == "profiles":
            for name, profile in sorted(policy["profiles"].items()):
                print(f"{name}\t{profile.get('description', '')}")
            return 0
        if args.handler == "prompt":
            print(render_prompt(policy, args.profile, args.task))
            return 0
        if args.handler == "init-run":
            print(json.dumps(make_run(policy, args.profile, args.task), ensure_ascii=False, indent=2))
            return 0
        run = load_json(args.run)
        report = audit_run(policy, run)
        if args.handler == "audit":
            if args.as_json:
                print(json.dumps(report, ensure_ascii=False, indent=2))
            else:
                print_audit(report)
            return 0 if report["complete"] else 1
        if args.handler == "next":
            print(report["next_gate"] or "complete")
            return 0 if report["complete"] else 1
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
