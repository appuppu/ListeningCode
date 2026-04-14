#!/usr/bin/env python3
"""
Generate mp3 audio files from problem JSON dialogue lines
using Google Cloud Text-to-Speech API.

Usage:
  python3 generate_audio.py                  # Process all problems in problems.yaml
  python3 generate_audio.py path/to/file.json  # Process a single JSON file
"""

import json
import os
import sys
import yaml
from google.cloud import texttospeech

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
PROBLEMS_YAML = os.path.join(SCRIPT_DIR, "problems.yaml")
DATA_DIR = os.path.join(PROJECT_ROOT, "listeningcode", "Resources", "Data")
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "listeningcode", "Resources", "Audio")

VOICES = {
    "interviewer": texttospeech.VoiceSelectionParams(
        language_code="en-US",
        name="en-US-Neural2-F",
    ),
    "candidate": texttospeech.VoiceSelectionParams(
        language_code="en-US",
        name="en-US-Neural2-D",
    ),
}

AUDIO_CONFIG = texttospeech.AudioConfig(
    audio_encoding=texttospeech.AudioEncoding.MP3,
    speaking_rate=1.0,
)


def process_json(json_path, client):
    """Generate audio for all lines in a problem JSON file."""
    with open(json_path, "r") as f:
        data = json.load(f)

    problem_id = data.get("id", os.path.basename(json_path).replace(".json", ""))
    sections = data.get("audio_script", {}).get("sections", [])

    lines = []
    for section in sections:
        for line in section.get("lines", []):
            lines.append(line)

    total = len(lines)
    generated = 0

    for i, line in enumerate(lines, 1):
        audio_file = line["audio_file"]
        output_path = os.path.join(OUTPUT_DIR, audio_file)

        if os.path.exists(output_path):
            continue

        speaker = line["speaker"]
        text = line["text"]
        voice = VOICES[speaker]

        synthesis_input = texttospeech.SynthesisInput(text=text)
        response = client.synthesize_speech(
            input=synthesis_input,
            voice=voice,
            audio_config=AUDIO_CONFIG,
        )

        with open(output_path, "wb") as out:
            out.write(response.audio_content)

        generated += 1
        print(f"  [{i}/{total}] Generated: {audio_file} ({speaker})")

    if generated == 0:
        print(f"  All {total} audio files already exist.")
    else:
        print(f"  Generated {generated}/{total} audio files.")


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
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    client = texttospeech.TextToSpeechClient()

    if len(sys.argv) > 1:
        # Process single file
        json_path = sys.argv[1]
        if not os.path.exists(json_path):
            sys.exit(f"File not found: {json_path}")
        print(f"Processing: {json_path}")
        process_json(json_path, client)
    else:
        # Process all problems
        problems = find_all_problem_jsons()
        if not problems:
            print("No problem JSON files found.")
            return

        print(f"Processing {len(problems)} problem(s)...\n")
        for title, json_path in problems:
            print(f"[{title}]")
            process_json(json_path, client)
            print()

    print("Audio generation complete.")


if __name__ == "__main__":
    main()
