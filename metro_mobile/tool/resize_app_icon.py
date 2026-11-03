#!/usr/bin/env python3
"""Tạo icon Android và iOS từ ảnh gốc của tool/generate_app_icon_test.dart."""
from pathlib import Path

from PIL import Image

full = Image.open("build/icon/full.png").convert("RGB")
foreground = Image.open("build/icon/foreground.png").convert("RGBA")
res = Path("android/app/src/main/res")
for name, size in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
    full.resize((size, size), Image.LANCZOS).save(res / f"mipmap-{name}/ic_launcher.png")
    fg = round(size * 108 / 48)
    foreground.resize((fg, fg), Image.LANCZOS).save(res / f"mipmap-{name}/ic_launcher_foreground.png")

(res / "mipmap-anydpi-v26").mkdir(exist_ok=True)
(res / "mipmap-anydpi-v26/ic_launcher.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
    '    <background android:drawable="@color/ic_launcher_background"/>\n'
    '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
    "</adaptive-icon>\n"
)
(res / "values/ic_launcher_background.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
    '    <color name="ic_launcher_background">#06192C</color>\n</resources>\n'
)

# App Store từ chối icon có kênh alpha nên iOS dùng ảnh RGB.
ios = Path("ios/Runner/Assets.xcassets/AppIcon.appiconset")
for path in ios.glob("*.png"):
    size = Image.open(path).size
    full.resize(size, Image.LANCZOS).save(path)
