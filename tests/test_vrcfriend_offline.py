"""Safety regression checks for the VRC Friend Connect read-only probe."""
import hashlib
import importlib.util
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from unittest.mock import patch

SOURCE = Path(__file__).resolve().parents[1] / "scripts" / "vrcfriend_offline.py"
spec = importlib.util.spec_from_file_location("vrcfriend_offline", SOURCE)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class ProbeSafetyTests(unittest.TestCase):
    @staticmethod
    def make_db(root):
        folder = root / "db"
        folder.mkdir()
        path = folder / "db_1.1.sqlite"
        with sqlite3.connect(path) as conn:
            conn.execute("CREATE TABLE friends (id TEXT, private_note TEXT)")
            conn.execute("INSERT INTO friends VALUES ('usr-secret', 'friend note')")
        return path

    def test_active_vr_never_reads_database(self):
        with patch.object(module, "require_idle", return_value=["vrchat.exe"]):
            with patch.object(module, "database_metadata") as read:
                result = module.probe(Path("unused"))
                self.assertEqual(result["status"], "skipped")
                read.assert_not_called()

    def test_schema_only_does_not_export_rows_or_change_db(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            path = self.make_db(root)
            digest = hashlib.sha256(path.read_bytes()).digest()
            with patch.object(module, "require_idle", return_value=[]):
                report = module.probe(root)
            self.assertEqual(report["rows_exported"], 0)
            text = json.dumps(report)
            self.assertIn("friends", text)
            self.assertNotIn("usr-secret", text)
            self.assertNotIn("friend note", text)
            self.assertEqual(hashlib.sha256(path.read_bytes()).digest(), digest)

    def test_corrupt_db_is_not_silent_noop(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / "db").mkdir()
            (root / "db" / "db_1.1.sqlite").write_bytes(b"bad sqlite")
            with patch.object(module, "require_idle", return_value=[]):
                with self.assertRaises(sqlite3.DatabaseError):
                    module.probe(root)

    def test_uncheckpointed_wal_causes_stop(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            path = self.make_db(root)
            Path(str(path) + "-wal").write_bytes(b"pending")
            with patch.object(module, "require_idle", return_value=[]):
                with self.assertRaises(module.ProbeError):
                    module.probe(root)

    def test_external_inference_endpoint_is_rejected(self):
        with self.assertRaises(module.ProbeError):
            module.label_schema({"databases": []}, "https://example.com/v1/systemone")


if __name__ == "__main__":
    unittest.main()
