# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ListeningCode is an iOS app for learning coding interview concepts through English listening practice. Users listen to interview-style dialogues between an interviewer and candidate discussing algorithm/system-design problems. Content is structured as NeetCode-style categories (Arrays & Hashing, Trees, Graphs, etc.) with problems presented as audio dialogues.

## Build & Run

This is a native SwiftUI app using Xcode (no CocoaPods/SPM dependencies):

```bash
# Build from command line
xcodebuild -project listeningcode.xcodeproj -scheme listeningcode -sdk iphonesimulator build

# Archive (for release)
xcodebuild -project listeningcode.xcodeproj -scheme listeningcode archive -archivePath build/ListeningCode.xcarchive
```

Open `listeningcode.xcodeproj` in Xcode for development. The app targets iOS with portrait-only orientation and background audio mode.

## Content Generation Pipeline

New problems are defined in `scripts/problems.yaml`, then generated via a 3-step pipeline:

```bash
python3 scripts/generate_all.py   # Runs all 3 steps below in order
python3 scripts/generate_content.py   # 1. Claude CLI → JSON dialogue scripts
python3 scripts/generate_audio.py     # 2. Google Cloud TTS → MP3 files
python3 scripts/generate_diagrams.py  # 3. Mermaid CLI → PNG diagrams
```

- `generate_content.py` processes 1 problem per run. It skips problems that already have a JSON file.
- `generate_audio.py` tracks cumulative TTS character usage against Google's free tier limit (1M chars).
- A launchd cron job (`scripts/com.listeningcode.generate.plist`) runs the pipeline every 30 minutes.

## Architecture

### Data Flow

`categories.json` → `{category-id}-problems.json` → `{problem-id}.json` (per-problem content with dialogue, prerequisites, solutions, diagrams)

All content JSON lives in `listeningcode/Resources/Data/{category-id}/`. Audio files go in `listeningcode/Resources/Audio/`.

### Content Loading (ContentLoader.swift)

`ContentLoader` resolves resources with a 3-tier fallback: **memory cache → disk cache → app bundle**. It can also fetch from a Cloudflare R2 CDN (currently disabled for bundled-only distribution). Audio URLs follow the same fallback pattern.

### Key Models

- `LCCategory` — category metadata (id, title, icon, problem count)
- `LCProblem` — problem metadata (id, title, difficulty, sort order). Free-tier gating logic is in `isFree(categorySortOrder:)`.
- `ProblemContent` — full problem data including `Prerequisites` (phrases, technical terms, Java methods), `Solution` levels, and `AudioScript` with `AudioSection`/`DialogueLine` hierarchy
- `ProblemProgress` — SwiftData `@Model` tracking per-problem listen state (completion, playback position, speed, listen count)

### View Hierarchy

`ContentView` → `RoadmapView` (category list) → `ProblemListView` → `ProblemDetailView` (audio player + transcript). A floating `MiniPlayerView` persists across navigation.

### State Management

- `AudioPlayerManager` — `@Observable` view model managing AVAudioPlayer playback, section/line tracking, speed control
- `SubscriptionManager` — `@Observable` StoreKit 2 integration for monthly/yearly subscriptions. Injected via `.environment()` at the app root.
- `ProblemProgress` — SwiftData persistence. The app auto-resets the database on migration failure.

### Subscription & Free Tier

Product IDs: `com.tenitaku.listeningcode.premium.monthly`, `com.tenitaku.listeningcode.premium.yearly`. Free access rules vary by category (defined in `LCProblem.isFree`).

## Content JSON Format

Each problem JSON contains:
- `prerequisites`: phrases, technical_terms, java_methods (used for glossary overlays)
- `solutions`: array of approaches with level (1=brute force, 2=better, 3=optimal), complexity, summary
- `audio_script.sections`: each section has `id`, `level`, `diagram` (Mermaid markup), and `lines` (speaker + text + audio_file)
- Audio file naming convention: `{problem-id}-{section-id}-{speaker-initial}{line-number}.mp3`

## Adding New Problems

1. Add entry to `scripts/problems.yaml` under the appropriate category
2. Run `python3 scripts/generate_all.py` (or wait for the cron job)
3. Add the generated JSON, audio, and diagram files to the Xcode project
4. Update `categories.json` problem_count if adding to a new or existing category
