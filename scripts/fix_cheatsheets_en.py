#!/usr/bin/env python3
"""
Re-translate English cheatsheets from the fixed Japanese versions.
5 parallel Claude CLI workers.
"""

import json
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
JP_DIR = os.path.join(PROJECT_ROOT, "docs", "cheatsheets")
EN_DIR = os.path.join(PROJECT_ROOT, "docs", "cheatsheets-english")

MAX_WORKERS = 5

PROMPT = """Translate the following Japanese coding interview cheatsheet into English.

## Rules
1. Keep the exact same Markdown structure, section names (translated), and formatting
2. Section mapping: 問題の本質→Problem, 核心のアイデア→Key Insight, 思考プロセス→Thought Process, 前提知識→Prerequisites, 計算量→Complexity, コード→Code
3. Do NOT add an "Algorithm" section — it does not exist in the source
4. Keep all code in Java — do NOT translate code
5. Translate Japanese comments in code to English comments
6. Be precise: always include subject, verb, and object
7. Output only the translated Markdown. No fences or explanation.

## Source (Japanese)
{content}"""


def translate_one(jp_path, en_path, label, index, total):
    with open(jp_path, "r") as f:
        content = f.read()

    try:
        result = subprocess.run(
            ["claude", "--print", "--output-format", "json"],
            input=PROMPT.format(content=content),
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

        os.makedirs(os.path.dirname(en_path), exist_ok=True)
        with open(en_path, "w") as f:
            f.write(text)
            if not text.endswith("\n"):
                f.write("\n")

        print(f"  DONE:  [{index}/{total}] {label}")
        return True
    except Exception as e:
        print(f"  FAILED: [{index}/{total}] {label} — {e}")
        return False


def main():
    tasks = []
    for cat_dir in sorted(os.listdir(JP_DIR)):
        cat_path = os.path.join(JP_DIR, cat_dir)
        if not os.path.isdir(cat_path):
            continue
        for fn in sorted(os.listdir(cat_path)):
            if not fn.endswith(".md"):
                continue
            jp_path = os.path.join(cat_path, fn)
            en_path = os.path.join(EN_DIR, cat_dir, fn)
            # Check if English version still has Algorithm section
            if os.path.exists(en_path):
                with open(en_path, "r") as f:
                    if "## Algorithm" not in f.read():
                        continue
            tasks.append((jp_path, en_path, f"{cat_dir}/{fn}"))

    if not tasks:
        print("All English cheatsheets are already fixed!")
        return

    print(f"{len(tasks)} to fix, {MAX_WORKERS} parallel workers\n")
    success = 0
    failed = 0

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {
            executor.submit(translate_one, jp, en, label, i + 1, len(tasks)): label
            for i, (jp, en, label) in enumerate(tasks)
        }
        for future in as_completed(futures):
            if future.result():
                success += 1
            else:
                failed += 1

    print(f"\nDone! Success: {success}, Failed: {failed}")


if __name__ == "__main__":
    main()
