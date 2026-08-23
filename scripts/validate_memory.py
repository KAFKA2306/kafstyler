#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

REQUIRED_HEADINGS = (
    "## Operating principles",
    "## Response preferences",
    "## Source routing",
    "## Memory admission rule",
    "## Excluded transient state",
)

TRANSIENT_PATTERNS = (
    ("dated snapshot", re.compile(r"\b20\d{2}[-/]\d{1,2}[-/]\d{1,2}\b")),
    ("Issue/PR snapshot", re.compile(r"\b(?:issue|pr)\s*#?\d+\b", re.IGNORECASE)),
    ("commit SHA", re.compile(r"\b(?=[0-9a-f]{7,40}\b)(?=[0-9a-f]*\d)[0-9a-f]{7,40}\b", re.IGNORECASE)),
    ("software version", re.compile(r"\bv?\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\b")),
    ("relative date", re.compile(r"(?:今日|明日|昨日|\btoday\b|\btomorrow\b|\byesterday\b)", re.IGNORECASE)),
)

SECRET_PATTERNS = (
    ("GitHub token", re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}\b")),
    ("GitHub fine-grained token", re.compile(r"\bgithub_pat_[A-Za-z0-9_]{20,}\b")),
    ("OpenAI-style secret", re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b")),
    ("Hugging Face token", re.compile(r"\bhf_[A-Za-z0-9]{20,}\b")),
    ("AWS access key", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
)


def _section_for_line(lines: list[str]) -> list[str | None]:
    current: str | None = None
    sections: list[str | None] = []
    for line in lines:
        if line.startswith("## "):
            current = line.strip()
        sections.append(current)
    return sections


def validate(text: str) -> list[str]:
    errors: list[str] = []
    lines = text.splitlines()
    sections = _section_for_line(lines)

    actual_headings = [line for line in lines if line.startswith("## ")]
    if actual_headings != list(REQUIRED_HEADINGS):
        errors.append(
            "section order/schema mismatch: expected " + " -> ".join(REQUIRED_HEADINGS)
        )

    seen_bullets: dict[str, int] = {}
    for number, (line, section) in enumerate(zip(lines, sections), start=1):
        stripped = line.strip()

        if section is not None and stripped and not line.startswith("## ") and not line.startswith("- "):
            errors.append(f"line {number}: section content must be one atomic top-level bullet")

        if line.startswith("- "):
            normalized = re.sub(r"\s+", " ", line.casefold())
            if normalized in seen_bullets:
                errors.append(
                    f"line {number}: duplicate memory bullet; first seen on line {seen_bullets[normalized]}"
                )
            else:
                seen_bullets[normalized] = number

        for label, pattern in SECRET_PATTERNS:
            if pattern.search(line):
                errors.append(f"line {number}: possible {label}")

        if section == "## Excluded transient state":
            continue

        for label, pattern in TRANSIENT_PATTERNS:
            if pattern.search(line):
                errors.append(f"line {number}: possible transient {label}")

    return errors


def main(argv: list[str] | None = None) -> int:
    args = list(sys.argv[1:] if argv is None else argv)
    path = Path(args[0]) if args else Path(__file__).resolve().parents[1] / "MEMORY.md"

    if not path.is_file():
        print(f"ERROR: memory file not found: {path}", file=sys.stderr)
        return 2

    errors = validate(path.read_text(encoding="utf-8"))
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print(f"OK: {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
