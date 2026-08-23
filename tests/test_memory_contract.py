from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]
MEMORY = ROOT / "MEMORY.md"
VALIDATOR = ROOT / "scripts" / "validate_memory.py"

spec = spec_from_file_location("validate_memory", VALIDATOR)
assert spec and spec.loader
validate_memory = module_from_spec(spec)
spec.loader.exec_module(validate_memory)


class MemoryContractTest(unittest.TestCase):
    def test_canonical_memory_is_valid(self):
        errors = validate_memory.validate(MEMORY.read_text(encoding="utf-8"))
        self.assertEqual([], errors)

    def test_dated_issue_and_version_snapshots_are_rejected(self):
        base = MEMORY.read_text(encoding="utf-8")
        injected = base.replace(
            "## Response preferences",
            "- PR #148 is open as of 2026-08-23 on v1.2.3.\n\n## Response preferences",
        )
        errors = validate_memory.validate(injected)
        self.assertTrue(any("Issue/PR snapshot" in error for error in errors))
        self.assertTrue(any("dated snapshot" in error for error in errors))
        self.assertTrue(any("software version" in error for error in errors))

    def test_excluded_section_can_name_transient_categories(self):
        base = MEMORY.read_text(encoding="utf-8")
        injected = base + "\n- Example excluded snapshot: PR #999 on 2026-08-23 at v9.9.9.\n"
        errors = validate_memory.validate(injected)
        self.assertFalse(any("transient" in error for error in errors))

    def test_secrets_are_rejected_even_in_excluded_section(self):
        base = MEMORY.read_text(encoding="utf-8")
        injected = base + "\n- Never store hf_abcdefghijklmnopqrstuvwxyz123456.\n"
        errors = validate_memory.validate(injected)
        self.assertTrue(any("Hugging Face token" in error for error in errors))

    def test_duplicate_bullets_are_rejected(self):
        base = MEMORY.read_text(encoding="utf-8")
        bullet = "- Respond in Japanese by default."
        injected = base.replace(bullet, f"{bullet}\n{bullet}")
        errors = validate_memory.validate(injected)
        self.assertTrue(any("duplicate memory bullet" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
