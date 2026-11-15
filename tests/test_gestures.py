#!/usr/bin/env python3
"""
Unit and integration tests for macOS Gestures Omarchy Plugin.
"""

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS_DIR = ROOT / "scripts"
import sys

sys.path.insert(0, str(SCRIPTS_DIR))
import macos_gestures_manager as mgm


class TestMacOSGestures(unittest.TestCase):
    def test_manifest_structure(self):
        manifest_path = ROOT / "manifest.json"
        self.assertTrue(manifest_path.exists())
        with open(manifest_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        self.assertEqual(data.get("schemaVersion"), 1)
        self.assertEqual(data.get("id"), "io.github.devmercenario.macos-gestures")
        self.assertEqual(data.get("kinds"), ["service"])
        self.assertEqual(data.get("entryPoints", {}).get("service"), "Service.qml")

    def test_generate_lua_standard_mode(self):
        config = {
            "enabled": True,
            "mode": "standard",
            "naturalScroll": True,
            "clickfinger": True,
            "workspaceSwipeFingers": 3,
            "drag3fg": False,
            "scrollFactor": 0.4,
        }
        lua = mgm.generate_lua(config)
        self.assertIn("natural_scroll = true", lua)
        self.assertIn("drag_3fg = 0", lua)
        self.assertIn("fingers = 3", lua)
        self.assertIn('direction = "horizontal"', lua)
        self.assertIn('action = "workspace"', lua)
        # Ensure vertical and pinch gestures are NOT present
        self.assertNotIn('direction = "vertical"', lua)
        self.assertNotIn('direction = "pinchin"', lua)
        self.assertNotIn('direction = "pinchout"', lua)

        # Syntax check with luac
        with tempfile.NamedTemporaryFile("w", suffix=".lua", delete=False) as tf:
            tf.write(lua)
            temp_path = tf.name
        try:
            res = subprocess.run(["luac", "-p", temp_path], capture_output=True, text=True)
            self.assertEqual(res.returncode, 0, f"Lua syntax error: {res.stderr}")
        finally:
            os.unlink(temp_path)

    def test_generate_lua_drag3fg_mode(self):
        config = {
            "enabled": True,
            "mode": "drag3fg",
            "naturalScroll": True,
            "clickfinger": True,
            "workspaceSwipeFingers": 4,
            "drag3fg": True,
            "scrollFactor": 0.4,
        }
        lua = mgm.generate_lua(config)
        self.assertIn("drag_3fg = 1", lua)
        self.assertIn("fingers = 4", lua)
        self.assertIn('direction = "horizontal"', lua)
        self.assertIn('action = "workspace"', lua)

        with tempfile.NamedTemporaryFile("w", suffix=".lua", delete=False) as tf:
            tf.write(lua)
            temp_path = tf.name
        try:
            res = subprocess.run(["luac", "-p", temp_path], capture_output=True, text=True)
            self.assertEqual(res.returncode, 0, f"Lua syntax error: {res.stderr}")
        finally:
            os.unlink(temp_path)

    def test_generate_lua_disabled(self):
        config = {"enabled": False}
        lua = mgm.generate_lua(config)
        self.assertIn("DISABLED", lua)
        self.assertNotIn("hl.gesture", lua)


if __name__ == "__main__":
    unittest.main()
