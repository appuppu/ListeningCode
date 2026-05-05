#!/usr/bin/env python3
"""
Generate cheatsheets in multiple languages from the Japanese source.
Runs 5 Claude CLI calls in parallel. Designed to be run via cron.

Usage:
  python3 scripts/generate_cheatsheets_i18n.py          # Generate all languages
  python3 scripts/generate_cheatsheets_i18n.py zh-CN     # Generate specific language
  python3 scripts/generate_cheatsheets_i18n.py ko es     # Generate multiple languages

Supported languages: zh-CN, zh-TW, ko, es, pt, hi
"""

import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
JP_DIR = os.path.join(PROJECT_ROOT, "docs", "cheatsheets")

MAX_WORKERS = 5

LANGUAGES = {
    "zh-CN": {"name": "Simplified Chinese", "dir": "cheatsheets-zh-cn"},
    "zh-TW": {"name": "Traditional Chinese", "dir": "cheatsheets-zh-tw"},
    "ko": {"name": "Korean", "dir": "cheatsheets-ko"},
    "es": {"name": "Spanish", "dir": "cheatsheets-es"},
    "pt": {"name": "Portuguese", "dir": "cheatsheets-pt"},
    "hi": {"name": "Hindi", "dir": "cheatsheets-hi"},
}

PROMPT = """Translate the following Japanese coding interview cheatsheet into {lang_name}.

## Rules
1. Keep the exact same Markdown structure and formatting
2. Translate section names to {lang_name}
3. Do NOT add an "Algorithm" section — it does not exist in the source
4. Keep all code in Java — do NOT translate code
5. Translate Japanese comments in code to {lang_name} comments
6. Be precise: always include subject, verb, and object
7. Keep technical terms (HashMap, TreeNode, etc.) in English
8. Output only the translated Markdown. No fences or explanation.

## Source (Japanese)
{content}"""


def translate_one(jp_path, out_path, lang_name, label, index, total):
    with open(jp_path, "r") as f:
        content = f.read()

    try:
        result = subprocess.run(
            ["claude", "--print", "--output-format", "json"],
            input=PROMPT.format(content=content, lang_name=lang_name),
            capture_output=True, text=True, timeout=180,
        )
        if result.returncode != 0:
            print(f"  FAILED: [{index}/{total}] {label}")
            return False

        response = json.loads(result.stdout)
        text = response.get("result", "")
        if not text:
            print(f"  FAILED: [{index}/{total}] {label} — empty")
            return False

        text = text.strip()
        if text.startswith("```"):
            lines = text.split("\n")[1:]
            if lines and lines[-1].strip() == "```":
                lines = lines[:-1]
            text = "\n".join(lines)

        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        with open(out_path, "w") as f:
            f.write(text)
            if not text.endswith("\n"):
                f.write("\n")

        print(f"  DONE:  [{index}/{total}] {label}")
        return True
    except Exception as e:
        print(f"  FAILED: [{index}/{total}] {label} — {e}")
        return False


def generate_language(lang_code):
    lang_info = LANGUAGES[lang_code]
    out_dir = os.path.join(PROJECT_ROOT, "docs", lang_info["dir"])

    tasks = []
    for cat_dir in sorted(os.listdir(JP_DIR)):
        cat_path = os.path.join(JP_DIR, cat_dir)
        if not os.path.isdir(cat_path):
            continue
        for fn in sorted(os.listdir(cat_path)):
            if not fn.endswith(".md"):
                continue
            jp_path = os.path.join(cat_path, fn)
            out_path = os.path.join(out_dir, cat_dir, fn)
            if os.path.exists(out_path):
                continue
            tasks.append((jp_path, out_path, f"{cat_dir}/{fn}"))

    if not tasks:
        print(f"[{lang_code}] All {lang_info['name']} cheatsheets already generated!")
        return 0, 0

    print(f"[{lang_code}] {len(tasks)} {lang_info['name']} cheatsheets to generate\n")
    success = 0
    failed = 0

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {
            executor.submit(translate_one, jp, out, lang_info["name"], label, i + 1, len(tasks)): label
            for i, (jp, out, label) in enumerate(tasks)
        }
        for future in as_completed(futures):
            if future.result():
                success += 1
            else:
                failed += 1

    return success, failed


def main():
    target_langs = sys.argv[1:] if len(sys.argv) > 1 else list(LANGUAGES.keys())

    for lang in target_langs:
        if lang not in LANGUAGES:
            print(f"Unknown language: {lang}. Supported: {', '.join(LANGUAGES.keys())}")
            continue
        success, failed = generate_language(lang)
        if success or failed:
            print(f"\n[{lang}] Done! Success: {success}, Failed: {failed}\n")


if __name__ == "__main__":
    main()
