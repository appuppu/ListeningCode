#!/usr/bin/env python3
"""
Fix all cheatsheet markdown files:
- Remove the アルゴリズム section
- Move its key info (入力/出力, notes) into code comments
Uses Claude CLI with 5 parallel workers.
"""

import json
import os
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "docs", "cheatsheets")
REFERENCE_FILE = os.path.join(OUTPUT_DIR, "arrays-and-hashing", "1kol6d.md")

MAX_WORKERS = 5

PROMPT_TEMPLATE = """以下のチートシートMarkdownを修正してください。

## 修正ルール
1. 「## アルゴリズム」セクションを完全に削除する
2. アルゴリズムセクションにあった重要な情報（入力/出力の説明、注意点、ステップの補足）はコードのコメントとして統合する
3. コードセクションの冒頭に `// 入力: ...` と `// 出力: ...` のコメントを追加する（アルゴリズムセクションの入力/出力の内容を移す）
4. コードの各行に、アルゴリズムセクションにあった説明や注意点を日本語コメントとして付ける
5. 「## 実装のキーポイント」セクションがもし残っていれば、それも削除してコードのコメントに統合する
6. それ以外のセクション（問題の本質、核心のアイデア、思考プロセス、前提知識、計算量）はそのまま残す

## 参考フォーマット（修正後はこの構成に従う）
{reference}

## 修正対象のMarkdown
{content}

修正後のMarkdownテキスト全体を出力してください。マークダウンフェンスや説明は不要です。"""


def load_reference():
    with open(REFERENCE_FILE, "r") as f:
        return f.read()


def fix_one(filepath, reference, index, total):
    label = f"[{index}/{total}] {os.path.basename(filepath)}"

    with open(filepath, "r") as f:
        content = f.read()

    # Skip if no algorithm section exists
    if "## アルゴリズム" not in content:
        print(f"  SKIP:  {label} (no algorithm section)")
        return True

    print(f"  START: {label}")

    prompt = PROMPT_TEMPLATE.format(reference=reference, content=content)

    try:
        result = subprocess.run(
            ["claude", "--print", "--output-format", "json"],
            input=prompt,
            capture_output=True,
            text=True,
            timeout=180,
        )

        if result.returncode != 0:
            print(f"  FAILED: {label} — CLI error")
            return False

        response = json.loads(result.stdout)
        text = response.get("result", "")
        if not text:
            print(f"  FAILED: {label} — empty result")
            return False

        text = text.strip()
        if text.startswith("```"):
            lines = text.split("\n")
            lines = lines[1:]
            if lines and lines[-1].strip() == "```":
                lines = lines[:-1]
            text = "\n".join(lines)

        with open(filepath, "w") as f:
            f.write(text)
            if not text.endswith("\n"):
                f.write("\n")

        print(f"  DONE:  {label}")
        return True

    except subprocess.TimeoutExpired:
        print(f"  FAILED: {label} — timeout")
        return False
    except Exception as e:
        print(f"  FAILED: {label} — {e}")
        return False


def main():
    reference = load_reference()

    files = []
    for root, dirs, filenames in os.walk(OUTPUT_DIR):
        for fn in filenames:
            if fn.endswith(".md"):
                fp = os.path.join(root, fn)
                # Skip the reference file itself
                if fp == REFERENCE_FILE:
                    continue
                files.append(fp)

    files.sort()
    print(f"Found {len(files)} files to check\n")

    success = 0
    failed = 0

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {
            executor.submit(fix_one, fp, reference, i + 1, len(files)): fp
            for i, fp in enumerate(files)
        }
        for future in as_completed(futures):
            if future.result():
                success += 1
            else:
                failed += 1

    print(f"\nDone! Success: {success}, Failed: {failed}")


if __name__ == "__main__":
    main()
