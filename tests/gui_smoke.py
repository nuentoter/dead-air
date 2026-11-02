#!/usr/bin/env python3
"""Offline checks for the browser GUI reference (not Godot gameplay integration)."""
from html.parser import HTMLParser
from pathlib import Path
import json
import re
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "gui/working_v2/dead_air_gui_v2"
PRODUCTION = ROOT / "gui/production_assets_v1/dead_air_production_assets"

class ResourceParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.resources = []
        self.ids = []
    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        if "id" in d:
            self.ids.append(d["id"])
        if tag in ("img", "script") and d.get("src"):
            self.resources.append(d["src"])

def check_png(path):
    raw = path.read_bytes()[:24]
    assert raw[:8] == bytes.fromhex("89504e470d0a1a0a"), f"Invalid PNG: {path}"
    width, height = struct.unpack(">II", raw[16:24])
    assert width > 0 and height > 0, f"Zero-sized PNG: {path}"
    return width, height

def main():
    html = (WEB / "index.html").read_text(encoding="utf-8")
    assert '<meta name="viewport"' in html, "Missing Android viewport scaling tag"
    parser = ResourceParser()
    parser.feed(html)
    assert len(parser.ids) == len(set(parser.ids)), "Duplicate DOM IDs"
    assert "quickLaunch" in parser.ids and "modal" in parser.ids, "Accessible touch controls or dialog missing"
    assert "7418000" in html, "Canonical NR-041 simulation frequency not in receiver visual prototype"
    assert "SIMULATED RECORDING" in html and "audioCaptured:false" in html, "Browser metadata must not claim audio capture"
    resources = set(parser.resources) | set(re.findall(r'url\\(["\\\']?([^)"\\\']+)["\\\']?\\)', html))
    for name in resources:
        if name.startswith(("http:", "https:", "data:")):
            raise AssertionError(f"Unexpected external/embedded resource: {name}")
        assert (WEB / name).is_file(), f"Missing GUI asset {name}"
        if name.lower().endswith(".png"):
            check_png(WEB / name)
    check_png(WEB / "assets/master.png")
    script = re.search(r"<script>(.*?)</script>", html, flags=re.DOTALL)
    assert script, "Expected standalone inline JavaScript"
    with tempfile.TemporaryDirectory() as directory:
        source = Path(directory) / "gui.js"
        source.write_text(script.group(1), encoding="utf-8")
        subprocess.run(["node", "--check", str(source)], check=True)

    atlas = json.loads((PRODUCTION / "atlas.json").read_text(encoding="utf-8"))
    assert atlas["reference_resolution"] == [1672, 941]
    for sprite in atlas["sprites"]:
        path = PRODUCTION / sprite["file"]
        assert path.exists(), f"Production atlas refers to missing sprite: {sprite['file']}"
        dimensions = check_png(path)
        assert dimensions == (sprite["width"], sprite["height"]), f"Atlas crop mismatch: {sprite['name']}"
    for files in atlas["button_states"].values():
        for name in files:
            assert (PRODUCTION / name).exists(), f"Missing button state image {name}"

    # The browser reference is intentionally not the Godot main scene.
    project = (ROOT / "project.godot").read_text(encoding="utf-8")
    assert 'run/main_scene="res://scenes/main.tscn"' in project
    print("DEAD AIR GUI checks passed: HTML resources, PNGs, atlas bounds, viewport, JS syntax, accessible controls.")
    print("NOTE: Browser artwork is not integrated into the Godot runtime. Touch testing on Android remains required.")

if __name__ == "__main__":
    main()
