from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[1]
MEMORY = ROOT / "MEMORY.md"
PROMPT = ROOT / "CHATGPT_MEMORY_PROMPT.md"
HEADINGS = ["## Principles", "## Preferences", "## Source routing", "## Memory rules"]
TRANSIENT = [
    re.compile(r"\b20\d{2}[-/]\d{1,2}[-/]\d{1,2}\b"),
    re.compile(r"\b(?:issue|pr)\s*#?\d+\b", re.I),
    re.compile(r"\b(?=[0-9a-f]{7,40}\b)(?=[0-9a-f]*\d)[0-9a-f]{7,40}\b", re.I),
    re.compile(r"\bv?\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?\b"),
]
SECRETS = [
    re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}\b"),
    re.compile(r"\bgithub_pat_[A-Za-z0-9_]{20,}\b"),
    re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
    re.compile(r"\bhf_[A-Za-z0-9]{20,}\b"),
    re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
]


def validate(text: str) -> list[str]:
    lines = text.splitlines()
    errors = []
    if [line for line in lines if line.startswith("## ")] != HEADINGS:
        errors.append("schema")

    section = None
    seen = set()
    for line in lines:
        if line.startswith("## "):
            section = line
            continue
        if section and line.strip() and not line.startswith("- "):
            errors.append("non-atomic")
        if line.startswith("- "):
            normalized = re.sub(r"\s+", " ", line.casefold())
            if normalized in seen:
                errors.append("duplicate")
            seen.add(normalized)
        if any(pattern.search(line) for pattern in SECRETS):
            errors.append("secret")
        if section != "## Memory rules" and any(pattern.search(line) for pattern in TRANSIENT):
            errors.append("transient")
    return errors


class MemoryContractTest(unittest.TestCase):
    def test_canonical_memory(self):
        self.assertEqual([], validate(MEMORY.read_text(encoding="utf-8")))

    def test_rejects_noise(self):
        base = MEMORY.read_text(encoding="utf-8")
        cases = (
            base.replace("## Preferences", "## Extra\n\n- x\n\n## Preferences"),
            base.replace("## Preferences\n", "## Preferences\n\nparagraph\n"),
            base.replace("- Respond in Japanese by default.", "- Respond in Japanese by default.\n- Respond in Japanese by default."),
            base.replace("## Preferences", "- PR #148 is open on 2026-08-23 at v1.2.3.\n\n## Preferences"),
            base + "\n- hf_abcdefghijklmnopqrstuvwxyz123456\n",
        )
        for text in cases:
            with self.subTest():
                self.assertTrue(validate(text))

    def test_prompt_points_to_canonical_memory(self):
        prompt = PROMPT.read_text(encoding="utf-8")
        for required in (
            "KAFKA2306/basic_prompts",
            "main/MEMORY.md",
            "KEEP:", "ADD:", "REPLACE:", "DELETE:", "MOVE-OUT:",
            "私が「実行」と明示した後だけ",
        ):
            self.assertIn(required, prompt)
        self.assertNotIn("Respond in Japanese by default.", prompt)


if __name__ == "__main__":
    unittest.main()
