#!/usr/bin/env python3
"""
Generate problem content JSON files using Claude Code CLI.
Reads problems.yaml and creates dialogue-format JSON for each problem
that doesn't already have a content file.

Generates 1 problem per run.

Requires: claude CLI, pyyaml
"""

import json
import os
import subprocess
import sys
import yaml

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
PROBLEMS_YAML = os.path.join(SCRIPT_DIR, "problems.yaml")
DATA_DIR = os.path.join(PROJECT_ROOT, "listeningcode", "Resources", "Data")

REFERENCE_PATH = os.path.join(DATA_DIR, "arrays-and-hashing", "contains-duplicate.json")

PROMPT_TEMPLATE = """You are a senior algorithm instructor creating content for an English listening-learning app focused on coding interview preparation.

Create a complete JSON file for this problem:
- Title: "{title}"
- Difficulty: {difficulty}
- Category: {category}
- Problem description hint: "{description}"

CRITICAL — CHARACTER LIMIT:
- The TOTAL character count of ALL dialogue text (sum of every "text" field in all lines) MUST be under 6,000 characters.
- Keep each line concise. Prioritize clarity over verbosity.
- Aim for 20-28 dialogue lines total across all sections.
- Intro: 4-6 lines, Each solution level: 4-6 lines, Summary: 2-4 lines.

CRITICAL — ORIGINALITY RULES:
- This is ORIGINAL educational content. Do NOT reference LeetCode, HackerRank, or any platform by name.
- Do NOT say "LeetCode problem number X" or "this is problem #Y".
- The title should be a natural English description (e.g., "Finding Duplicates in an Array" not "Contains Duplicate").
- The interviewer presents the problem as a real interview scenario, not as a reference to an existing problem.
- Frame the Introduction as a real interview: the interviewer describes the problem scenario, confirms input/output, discusses edge cases and constraints with the candidate BEFORE solving.

INTRODUCTION SECTION REQUIREMENTS:
The intro section (level 0) MUST include this flow in the dialogue:
1. Interviewer presents the problem in natural language (as if in a real interview)
2. Candidate confirms understanding, asks clarifying questions about constraints:
   - Input format and types
   - Edge cases (empty array, single element, all same, etc.)
   - Expected return type
3. Interviewer answers the clarifying questions
4. Candidate summarizes the problem before proceeding to solutions

The JSON must follow this EXACT structure (interview dialogue format):

{reference_structure}

RULES:
1. Audio file naming: "{problem_id}-{{section_id}}-{{speaker_initial}}{{line_number}}.mp3"
   - speaker_initial: "i" for interviewer, "c" for candidate
   - Example: "{problem_id}-intro-i1.mp3", "{problem_id}-bf-c1.mp3"
2. Section IDs: "intro", "brute-force", descriptive approach name (e.g., "two-pointer", "hashmap"), "optimal", "summary"
3. Include 3 solution levels when possible:
   - Level 1: Brute Force (most naive)
   - Level 2: Better (improved but not optimal)
   - Level 3: Optimal (best complexity)
   - If only 2 meaningful approaches exist, use Level 1 and Level 2 (NOT Level 1 and Level 3). Always number sequentially.
4. Prerequisites:
   - phrases: 4-6 common English interview phrases used in the dialogue
   - technical_terms: 4-6 key CS concepts
   - java_methods: 3-5 Java methods relevant to the solution
5. Each section needs a "diagram" field with Mermaid markup.
   The diagram MUST visualize the specific example used in the dialogue.
   When the candidate walks through an example (e.g., array [3, 1, 3, 4]), the diagram should show that exact example step by step.
   - Intro: visualize the example input and the question being asked
   - Solution levels: show the step-by-step process of the approach using the same example from the dialogue
   - Summary: comparison chart of all approaches
   Colors: Level 1 = blue (#60a5fa), Level 2 = purple (#a78bfa), Level 3 = orange (#fb923c)
   Intro = red highlights (#f87171), Summary = comparison chart
6. TTS-friendly: spell out symbols ("O of n" not "O(n)", "n-squared" not "n²")
7. All content in English.

Return ONLY the raw JSON text. No markdown fences, no explanation, no file creation.
Do NOT use any tools. Do NOT write files. Just output the JSON text directly."""


def load_reference_structure():
    """Load a simplified structure description from the reference JSON."""
    if not os.path.exists(REFERENCE_PATH):
        return "(Reference file not found. Use contains-duplicate.json format.)"

    simplified = {
        "id": "problem-slug",
        "title": "Problem Title (descriptive English)",
        "difficulty": "easy|medium|hard",
        "category": "category-id",
        "prerequisites": {
            "phrases": [{"phrase": "example phrase", "explanation": "what it means"}],
            "technical_terms": [{"term": "Example", "definition": "what it is"}],
            "java_methods": [{"signature": "method()", "description": "what it does"}],
        },
        "concept": "Problem statement and core question.",
        "solutions": [
            {
                "level": 1,
                "label": "Approach Name",
                "time_complexity": "O(...)",
                "space_complexity": "O(...)",
                "summary": "Brief description.",
            }
        ],
        "audio_script": {
            "sections": [
                {
                    "id": "section-id",
                    "level": 0,
                    "title": "Section Title",
                    "diagram": "graph TD\\n    A --> B",
                    "lines": [
                        {
                            "speaker": "interviewer|candidate",
                            "text": "Dialogue text here.",
                            "audio_file": "problem-id-section-speaker-num.mp3",
                        }
                    ],
                }
            ]
        },
    }
    return json.dumps(simplified, indent=2)


def get_problems_to_generate():
    """Read problems.yaml and find problems without content JSON."""
    if not os.path.exists(PROBLEMS_YAML):
        print("No problems.yaml found.")
        return []

    with open(PROBLEMS_YAML, "r") as f:
        categories = yaml.safe_load(f)

    if not categories:
        return []

    to_generate = []
    for cat in categories:
        category_id = cat["category"]
        category_dir = os.path.join(DATA_DIR, category_id)

        for problem in cat.get("problems", []):
            content_file = os.path.join(category_dir, f"{problem['id']}.json")
            if not os.path.exists(content_file):
                to_generate.append(
                    {
                        "category_id": category_id,
                        "category_dir": category_dir,
                        "content_file": content_file,
                        **problem,
                    }
                )

    return to_generate


def generate_content(problem, reference_structure):
    """Call Claude Code CLI to generate problem content JSON."""
    prompt = PROMPT_TEMPLATE.format(
        title=problem["title"],
        difficulty=problem["difficulty"],
        category=problem["category_id"],
        description=problem.get("description", problem["title"]),
        problem_id=problem["id"],
        reference_structure=reference_structure,
    )

    result = subprocess.run(
        ["claude", "--print", "--output-format", "json"],
        input=prompt,
        capture_output=True,
        text=True,
        timeout=600,
    )

    if result.returncode != 0:
        raise RuntimeError(
            f"Claude CLI failed (code {result.returncode}):\n"
            f"  stdout: {result.stdout[:500]}\n"
            f"  stderr: {result.stderr[:500]}"
        )

    # Parse Claude Code response
    claude_response = json.loads(result.stdout)
    result_text = claude_response.get("result", "")

    if not result_text:
        raise RuntimeError(f"Claude returned empty result. Full response: {result.stdout[:2000]}")

    print(f"  Result preview: {result_text[:200]}...")

    # Strip markdown fences if present
    result_text = result_text.strip()
    if result_text.startswith("```"):
        lines = result_text.split("\n")
        lines = lines[1:]
        if lines and lines[-1].strip() == "```":
            lines = lines[:-1]
        result_text = "\n".join(lines)

    return json.loads(result_text)


def update_problems_json(category_dir, category_id, problem):
    """Update or create {category-id}-problems.json for the category."""
    problems_file = os.path.join(category_dir, f"{category_id}-problems.json")

    if os.path.exists(problems_file):
        with open(problems_file, "r") as f:
            problems_list = json.load(f)
    else:
        problems_list = []

    if any(p["id"] == problem["id"] for p in problems_list):
        return

    problems_list.append(
        {
            "id": problem["id"],
            "title": problem["title"],
            "difficulty": problem["difficulty"],
            "sort_order": len(problems_list),
            "content_file": f"{problem['id']}.json",
            "leetcode_url": problem.get("leetcode_url", ""),
        }
    )

    with open(problems_file, "w") as f:
        json.dump(problems_list, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"  Updated {problems_file}")


def main():
    problems = get_problems_to_generate()

    if not problems:
        print("No new problems to generate content for.")
        return

    # Only generate 1 problem per run
    problem = problems[0]
    remaining = len(problems) - 1

    reference_structure = load_reference_structure()

    print(f"Generating content for 1 problem ({remaining} remaining)...\n")
    print(f"[1/1] {problem['title']}...")

    try:
        content = generate_content(problem, reference_structure)

        os.makedirs(problem["category_dir"], exist_ok=True)

        with open(problem["content_file"], "w") as f:
            json.dump(content, f, indent=2, ensure_ascii=False)
            f.write("\n")

        print(f"  -> {problem['content_file']}")

        update_problems_json(
            problem["category_dir"], problem["category_id"], problem
        )

    except json.JSONDecodeError as e:
        print(f"  FAILED: Invalid JSON from Claude: {e}")
    except subprocess.TimeoutExpired:
        print(f"  FAILED: Claude CLI timed out (600s)")
    except RuntimeError as e:
        print(f"  FAILED: {e}")

    print("\nContent generation complete.")


if __name__ == "__main__":
    main()
