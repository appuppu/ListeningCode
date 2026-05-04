#!/usr/bin/env python3
"""
Generate Japanese cheatsheet markdown files for all algorithm problems.
Reads problem data from listeningcode-web and generates one markdown file per problem.
Runs 5 Claude CLI calls in parallel for speed.

Usage:
  python3 scripts/generate_cheatsheets.py
"""

import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
WEB_PROJECT = os.path.join(os.path.dirname(PROJECT_ROOT), "listeningcode-web")
CATEGORIES_FILE = os.path.join(WEB_PROJECT, "lib", "problems", "categories-light.json")
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "docs", "cheatsheets")
REFERENCE_FILE = os.path.join(OUTPUT_DIR, "arrays-and-hashing", "two-sum.md")

MAX_WORKERS = 5

PROMPT_TEMPLATE = """あなたはコーディング面接の教育者です。以下の問題について、日本語のチートシートMarkdownを作成してください。

## 対象問題
- タイトル: {title}
- 難易度: {difficulty}
- カテゴリ: {category}
- 問題の説明: {concept}

## 最適解の情報
- アプローチ名: {solution_label}
- 計算量: Time {time_complexity}, Space {space_complexity}
- 概要: {solution_summary}
- コード:
```java
{hint_code}
```

## 参考フォーマット（このフォーマットに厳密に従ってください）
{reference}

## ルール
1. フォーマットは参考フォーマットと完全に同じ構成にすること（セクション名、順番、スタイル）
2. 「実装のキーポイント」セクションは作らない。その内容はアルゴリズムの各ステップ内に統合する
3. 全て日本語で書く（コードとメソッド名は英語のまま）
4. 主語・述語・目的語を明確にする。「何が」「何を」「どうする」を省略しない
5. 思考プロセスは最適解に至る思考のみ（ブルートフォースからの改善過程は不要）
6. 思考プロセスとアルゴリズムの各ステップは対応させる
7. アルゴリズムには必ず「入力」「出力」を明記し、最終的に何を返すかを明確にする
8. 前提知識では、使用するJavaのデータ構造・メソッド・概念をコード例付きで説明する
9. コードには日本語コメントを付ける
10. 核心のアイデアは1-2文で、この問題を解く上での最も重要な洞察を書く

Markdownテキストのみを出力してください。マークダウンフェンスや説明は不要です。"""


def load_reference():
    if os.path.exists(REFERENCE_FILE):
        with open(REFERENCE_FILE, "r") as f:
            return f.read()
    return "(参考ファイルなし)"


def load_problems():
    with open(CATEGORIES_FILE, "r") as f:
        categories = json.load(f)

    algo_cats = [c for c in categories if c["sortOrder"] < 18]

    problems = []
    for cat in algo_cats:
        data_file = os.path.join(WEB_PROJECT, "public", "data", f"{cat['id']}.json")
        if not os.path.exists(data_file):
            print(f"  SKIP: {cat['id']} (no data file)")
            continue
        with open(data_file, "r") as f:
            cat_problems = json.load(f)
        for p in cat_problems:
            problems.append({
                "category_id": cat["id"],
                "category_title": cat["title"],
                **p,
            })
    return problems


def generate_one(problem, reference, index, total):
    output_dir = os.path.join(OUTPUT_DIR, problem["category_id"])
    output_file = os.path.join(output_dir, f"{problem['id']}.md")
    os.makedirs(output_dir, exist_ok=True)

    label = f"[{index}/{total}] {problem['category_title']} / {problem['title']}"
    print(f"  START: {label}")

    best_solution = problem["solutions"][-1]

    prompt = PROMPT_TEMPLATE.format(
        title=problem["title"],
        difficulty=problem["difficulty"],
        category=problem["category_title"],
        concept=problem.get("concept", ""),
        solution_label=best_solution.get("label", ""),
        time_complexity=best_solution.get("timeComplexity", ""),
        space_complexity=best_solution.get("spaceComplexity", ""),
        solution_summary=best_solution.get("summary", ""),
        hint_code=best_solution.get("hintCode", "// コードなし"),
        reference=reference,
    )

    try:
        result = subprocess.run(
            ["claude", "--print", "--output-format", "json"],
            input=prompt,
            capture_output=True,
            text=True,
            timeout=180,
        )

        if result.returncode != 0:
            print(f"  FAILED: {label} — CLI error: {result.stderr[:200]}")
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

        with open(output_file, "w") as f:
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
    print("Loading problems...")
    problems = load_problems()
    print(f"Found {len(problems)} algorithm problems\n")

    reference = load_reference()

    to_generate = []
    for p in problems:
        output_file = os.path.join(OUTPUT_DIR, p["category_id"], f"{p['id']}.md")
        if os.path.exists(output_file):
            continue
        to_generate.append(p)

    already = len(problems) - len(to_generate)
    if not to_generate:
        print("All cheatsheets already generated!")
        return

    print(f"{len(to_generate)} to generate ({already} already exist)")
    print(f"Running {MAX_WORKERS} parallel workers...\n")

    success = 0
    failed = 0

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {
            executor.submit(generate_one, p, reference, i + 1, len(to_generate)): p
            for i, p in enumerate(to_generate)
        }
        for future in as_completed(futures):
            if future.result():
                success += 1
            else:
                failed += 1

    print(f"\nDone! Success: {success}, Failed: {failed}")


if __name__ == "__main__":
    main()
