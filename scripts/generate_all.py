#!/usr/bin/env python3
"""
Master pipeline: generates content, audio, and diagrams for all problems
listed in problems.yaml that don't already have generated assets.

Pipeline:
  1. generate_content.py  — Create JSON dialogue scripts via Claude API
  2. generate_audio.py    — Create mp3 files via Google Cloud TTS
  3. generate_diagrams.py — Create PNG diagrams via Mermaid CLI

Usage:
  python3 generate_all.py
"""

import os
import subprocess
import sys
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def run_step(name, script):
    """Run a generation step and return success status."""
    print(f"\n{'='*60}")
    print(f"  Step: {name}")
    print(f"{'='*60}\n")

    script_path = os.path.join(SCRIPT_DIR, script)
    result = subprocess.run(
        [sys.executable, script_path],
        cwd=SCRIPT_DIR,
    )

    if result.returncode != 0:
        print(f"\n  WARNING: {name} exited with code {result.returncode}")
        return False
    return True


def main():
    start = datetime.now()
    print(f"ListeningCode Generation Pipeline")
    print(f"Started: {start.strftime('%Y-%m-%d %H:%M:%S')}")

    steps = [
        ("Content Generation (Claude API)", "generate_content.py"),
        ("Audio Generation (Google TTS)", "generate_audio.py"),
        ("Diagram Generation (Mermaid)", "generate_diagrams.py"),
    ]

    results = []
    for name, script in steps:
        success = run_step(name, script)
        results.append((name, success))

    elapsed = datetime.now() - start
    print(f"\n{'='*60}")
    print(f"  Pipeline Complete ({elapsed.total_seconds():.1f}s)")
    print(f"{'='*60}")

    for name, success in results:
        status = "OK" if success else "FAILED"
        print(f"  [{status}] {name}")

    print()


if __name__ == "__main__":
    main()
