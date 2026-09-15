import json
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parents[1]


class PromptBoundaryTest(unittest.TestCase):
    def setUp(self):
        self.contract = json.loads((ROOT / "prompt-boundary.json").read_text(encoding="utf-8"))

    def test_authorities_and_privacy_are_explicit(self):
        self.assertEqual(self.contract["newPromptAuthority"], "KAFKA2306/prompt-vault")
        self.assertEqual(self.contract["knowledgeAuthority"], "KAFKA2306/graphiti")
        self.assertFalse(self.contract["rules"]["graphitiRawDataAllowed"])
        self.assertFalse(self.contract["rules"]["secretOrPrivatePromotionAllowed"])
        self.assertEqual(self.contract["rules"]["newReusablePrompt"], "prompt-vault")
        self.assertEqual(self.contract["rules"]["rawFactEpisodeLesson"], "graphiti")

    def test_inventory_is_machine_decidable_and_paths_exist(self):
        allowed = {"remain", "migrate"}
        inventory = self.contract["inventory"]
        self.assertTrue(inventory)
        self.assertEqual(len({item["path"] for item in inventory}), len(inventory))
        for item in inventory:
            with self.subTest(path=item["path"]):
                self.assertIn(item["disposition"], allowed)
                self.assertTrue(item["reason"].strip())
                self.assertTrue((ROOT / item["path"]).exists())

    def test_repository_authority_documents_point_to_contract(self):
        for name in ("README.md", "AGENTS.md"):
            text = (ROOT / name).read_text(encoding="utf-8")
            with self.subTest(name=name):
                self.assertIn("prompt-boundary.json", text)
                self.assertIn("KAFKA2306/prompt-vault", text)
                self.assertIn("KAFKA2306/graphiti", text)


if __name__ == "__main__":
    unittest.main()
