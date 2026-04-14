#!/usr/bin/env python3
"""
Generate PNG diagram images from Mermaid markup in problem JSON files.

Usage:
  python3 generate_diagrams.py                  # Process all problems in problems.yaml
  python3 generate_diagrams.py path/to/file.json  # Process a single JSON file

Prerequisites: npm install -g @mermaid-js/mermaid-cli
"""

import json
import os
import shutil
import subprocess
import sys
import tempfile
import yaml

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
PROBLEMS_YAML = os.path.join(SCRIPT_DIR, "problems.yaml")
DATA_DIR = os.path.join(PROJECT_ROOT, "listeningcode", "Resources", "Data")
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "listeningcode", "Resources", "Audio")


def process_json(json_path):
    """Generate diagrams for all sections in a problem JSON file."""
    with open(json_path, "r") as f:
        data = json.load(f)

    problem_id = data.get("id", os.path.basename(json_path).replace(".json", ""))
    sections = data.get("audio_script", {}).get("sections", [])

    diagrams = [
        (s["id"], s["diagram"])
        for s in sections
        if "diagram" in s and s["diagram"]
    ]

    total = len(diagrams)
    generated = 0

    for i, (section_id, mermaid_text) in enumerate(diagrams, 1):
        filename = f"{problem_id}-{section_id}-diagram.png"
        output_path = os.path.join(OUTPUT_DIR, filename)

        if os.path.exists(output_path):
            continue

        with tempfile.NamedTemporaryFile(mode="w", suffix=".mmd", delete=False) as tmp:
            tmp.write(mermaid_text)
            tmp_path = tmp.name

        try:
            subprocess.run(
                [
                    "mmdc",
                    "-i", tmp_path,
                    "-o", output_path,
                    "-b", "transparent",
                    "-w", "800",
                    "-s", "2",
                ],
                check=True,
                capture_output=True,
                text=True,
            )
            generated += 1
            print(f"  [{i}/{total}] Generated: {filename}")
        except subprocess.CalledProcessError as e:
            print(f"  [{i}/{total}] FAILED: {filename}")
            print(f"    stderr: {e.stderr}")
        finally:
            os.unlink(tmp_path)

    if generated == 0 and total > 0:
        print(f"  All {total} diagrams already exist.")
    elif total == 0:
        print("  No diagrams found in JSON.")
    else:
        print(f"  Generated {generated}/{total} diagrams.")


def find_all_problem_jsons():
    """Find all problem JSON files based on problems.yaml."""
    if not os.path.exists(PROBLEMS_YAML):
        return []

    with open(PROBLEMS_YAML, "r") as f:
        categories = yaml.safe_load(f)

    if not categories:
        return []

    paths = []
    for cat in categories:
        category_id = cat["category"]
        for problem in cat.get("problems", []):
            json_path = os.path.join(DATA_DIR, category_id, f"{problem['id']}.json")
            if os.path.exists(json_path):
                paths.append((problem["title"], json_path))
    return paths


def main():
    if shutil.which("mmdc") is None:
        sys.exit("Error: mmdc not found. Install: npm install -g @mermaid-js/mermaid-cli")

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    if len(sys.argv) > 1:
        json_path = sys.argv[1]
        if not os.path.exists(json_path):
            sys.exit(f"File not found: {json_path}")
        print(f"Processing: {json_path}")
        process_json(json_path)
    else:
        problems = find_all_problem_jsons()
        if not problems:
            print("No problem JSON files found.")
            return

        print(f"Processing {len(problems)} problem(s)...\n")
        for title, json_path in problems:
            print(f"[{title}]")
            process_json(json_path)
            print()

    print("Diagram generation complete.")


if __name__ == "__main__":
    main()
