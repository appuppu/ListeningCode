import SwiftUI
import SwiftData

struct ProblemDetailView: View {
    let problem: LCProblem
    @Environment(\.modelContext) private var modelContext
    @Query private var allProgress: [ProblemProgress]
    @State private var audioManager = AudioPlayerManager()
    @State private var content: ProblemContent?
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @State private var showPrerequisites = false
    @State private var showHeader = true
    @State private var showPaywall = false

    private var progress: ProblemProgress? {
        allProgress.first { $0.problemId == problem.id }
    }

    private var sectionLabel: String {
        let categories = ContentLoader.loadCategories().sorted { $0.sortOrder < $1.sortOrder }
        let catId = findCategoryId()
        let catNumber = (categories.firstIndex { $0.id == catId } ?? 0) + 1
        return "\(catNumber)-\(problem.sectionNumber)"
    }

    var body: some View {
        if let content {
            VStack(spacing: 0) {
                // Collapsible header
                if showHeader {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            DifficultyBadge(difficulty: problem.difficulty)

                            Spacer()

                            Button {
                                showPrerequisites = true
                            } label: {
                                Label("Prerequisites", systemImage: "book")
                                    .font(.subheadline)
                            }
                        }

                        Text(content.concept)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)

                        HStack(spacing: 12) {
                            ForEach(content.solutions) { solution in
                                SolutionPill(solution: solution)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))

                    Divider()
                }

                // Transcript
                TranscriptView(
                    problemId: content.id,
                    sections: content.audioScript.sections,
                    currentSectionId: audioManager.currentSectionId,
                    currentLineId: audioManager.currentLineId,
                    glossary: content.prerequisites.allGlossaryKeys
                ) { lineId in
                    audioManager.seekToLine(lineId)
                }

                Divider()

                // Audio controls
                AudioControlsView(audioManager: audioManager)
            }
            .navigationTitle("\(sectionLabel). \(problem.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        if let urlString = problem.leetcodeUrl,
                           let url = URL(string: urlString) {
                            Link(destination: url) {
                                Image(systemName: "link.circle")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showHeader.toggle()
                            }
                        } label: {
                            Image(systemName: showHeader ? "chevron.up.circle" : "chevron.down.circle")
                                .foregroundStyle(.secondary)
                        }

                        Button {
                            toggleCompleted()
                        } label: {
                            Image(systemName: progress?.isCompleted == true
                                  ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundStyle(progress?.isCompleted == true ? .green : .secondary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showPrerequisites) {
                PrerequisitesSheetView(prerequisites: content.prerequisites)
            }
            .onDisappear {
                saveProgress()
                audioManager.tearDown()
            }
        } else if subscriptionManager.isLocked(problem) {
            VStack(spacing: 16) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("Premium Content")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Subscribe to unlock this problem.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("View Plans") { showPaywall = true }
                    .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        } else {
            ProgressView("Loading...")
                .onAppear { loadContent() }
        }
    }

    private func loadContent() {
        guard let loaded = ContentLoader.loadProblemContent(
            category: findCategoryId(),
            problem: problem.id
        ) else { return }

        content = loaded
        audioManager.load(sections: loaded.audioScript.sections, title: loaded.title)

        if let saved = progress {
            audioManager.playbackSpeed = saved.lastPlaybackSpeed
            if saved.lastPlaybackPosition > 0 {
                audioManager.seekGlobal(to: saved.lastPlaybackPosition)
            }
        }
    }

    private func findCategoryId() -> String {
        if let p = progress {
            return p.categoryId
        }
        let categories = ContentLoader.loadCategories()
        for cat in categories {
            let problems = ContentLoader.loadProblems(forCategory: cat.id)
            if problems.contains(where: { $0.id == problem.id }) {
                return cat.id
            }
        }
        return ""
    }

    private func saveProgress() {
        if let existing = progress {
            existing.lastPlaybackPosition = audioManager.totalCurrentTime
            existing.lastPlaybackSpeed = audioManager.playbackSpeed
            existing.lastListenedDate = Date()
        } else {
            let newProgress = ProblemProgress(
                problemId: problem.id,
                categoryId: findCategoryId(),
                lastPlaybackPosition: audioManager.totalCurrentTime,
                lastPlaybackSpeed: audioManager.playbackSpeed,
                lastListenedDate: Date()
            )
            modelContext.insert(newProgress)
        }
    }

    private func toggleCompleted() {
        if let existing = progress {
            existing.isCompleted.toggle()
        } else {
            let newProgress = ProblemProgress(
                problemId: problem.id,
                categoryId: findCategoryId(),
                isCompleted: true,
                lastListenedDate: Date()
            )
            modelContext.insert(newProgress)
        }
    }
}

private struct SolutionPill: View {
    let solution: Solution

    private var color: Color {
        switch solution.level {
        case 1: .blue
        case 2: .purple
        case 3: .orange
        default: .secondary
        }
    }

    var body: some View {
        VStack(spacing: 2) {
            Text("L\(solution.level)")
                .font(.caption2)
                .fontWeight(.bold)
            Text(solution.timeComplexity)
                .font(.caption2)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
}
