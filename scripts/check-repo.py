#!/usr/bin/env python3
"""Check maintained Markdown frontmatter and local links without an LLM."""
import argparse
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: python3 -m pip install PyYAML")

FRONTMATTER = re.compile(r"\A---\r?\n(.*?)\r?\n---(?:\r?\n|\Z)", re.S)
HEADING = re.compile(r"^#{1,6}\s+(.+?)\s*#*\s*$", re.M)
LINK = re.compile(r"(?<!!)\[[^\]\n]+\]\(([^)\s]+)(?:\s+[^)]*)?\)")
FENCE = re.compile(r"^\s*(\x60{3}|~{3})")
SKIP = {".git", "node_modules", ".venv", "venv", ".cache"}


def unfenced(content):
    result = []
    active = None
    for line in content.splitlines(keepends=True):
        m = FENCE.match(line)
        if m:
            marker = m.group(1)[0]
            active = None if active == marker else marker if active is None else active
            result.append("\n")
        else:
            result.append("\n" if active else line)
    return "".join(result)


def anchors(content):
    seen = {}
    result = set()
    for match in HEADING.finditer(unfenced(content)):
        name = re.sub(r"<[^>]+>", "", match.group(1)).lower()
        name = re.sub(r"[^\w\s-]", "", name, flags=re.UNICODE)
        key = re.sub(r"\s+", "-", name.strip())
        count = seen.get(key, 0)
        seen[key] = count + 1
        result.add(f"{key}-{count}" if count else key)
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    root = args.root.resolve()
    docs = []
    for folder, dirs, names in os.walk(root):
        dirs[:] = [d for d in dirs if d not in SKIP]
        docs.extend(Path(folder) / name for name in names if name.endswith(".md"))
    docs.sort()
    errors = []
    content = {p: p.read_text(encoding="utf-8") for p in docs}
    heading_map = {p: anchors(text) for p, text in content.items()}

    for path, source in content.items():
        display = path.relative_to(root).as_posix()
        special = path.name in ("index.md", "log.md")
        match = FRONTMATTER.match(source)
        if special and match:
            # The root index may declare only okf_version; all other reserved files have no frontmatter.
            try:
                doc = yaml.safe_load(match.group(1))
            except yaml.YAMLError as exc:
                errors.append(f"{display}:1:yaml:{exc}")
                doc = None
            if path != root / "index.md" or not isinstance(doc, dict) or set(doc) != {"okf_version"}:
                errors.append(f"{display}:1:reserved-frontmatter:invalid index/log frontmatter")
        elif not special:
            if not match:
                errors.append(f"{display}:1:frontmatter:missing YAML frontmatter")
            else:
                try:
                    data = yaml.safe_load(match.group(1))
                    if not isinstance(data, dict):
                        errors.append(f"{display}:1:yaml:expected mapping")
                    elif path.parent == root / "rules":
                        if data.get("trigger") not in ("always_on", "model_decision", "glob", "manual"):
                            errors.append(f"{display}:1:rule:invalid trigger")
                    elif path.name != "SKILL.md":
                        if not data.get("type") or not data.get("description") or not isinstance(data.get("tags"), list) or not data["tags"]:
                            errors.append(f"{display}:1:okf:missing type/description/nonempty tags")
                except yaml.YAMLError as exc:
                    errors.append(f"{display}:1:yaml:{exc}")

        text = unfenced(source)
        for link in LINK.finditer(text):
            href = link.group(1)
            parsed = urlsplit(href)
            if parsed.scheme or parsed.netloc or href.startswith("//"):
                continue
            dest = (path.parent / unquote(parsed.path)).resolve() if parsed.path else path
            line = text.count("\n", 0, link.start()) + 1
            if not dest.exists():
                errors.append(f"{display}:{line}:link:missing {href}")
            elif parsed.fragment and dest in heading_map and unquote(parsed.fragment) not in heading_map[dest]:
                errors.append(f"{display}:{line}:anchor:missing {href}")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
