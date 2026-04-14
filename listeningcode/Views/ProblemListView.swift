import SwiftUI
import SwiftData

struct ProblemListView: View {
    let category: LCCategory
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @Query private var allProgress: [ProblemProgress]
    @State private var showPaywall = false

    private var problems: [LCProblem] {
        ContentLoader.loadProblems(forCategory: category.id)
            .sorted(by: { $0.sortOrder < $1.sortOrder })
    }

    var body: some View {
        List {
            ForEach(problems) { problem in
                let locked = subscriptionManager.isLocked(problem)

                if locked {
                    Button {
                        showPaywall = true
                    } label: {
                        ProblemRowView(
                            problem: problem,
                            categoryNumber: category.sortOrder + 1,
                            isCompleted: false,
                            isLocked: true
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink(value: problem) {
                        ProblemRowView(
                            problem: problem,
                            categoryNumber: category.sortOrder + 1,
                            isCompleted: isCompleted(problem),
                            isLocked: false
                        )
                    }
                }
            }
        }
        .navigationTitle(category.title)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private func isCompleted(_ problem: LCProblem) -> Bool {
        allProgress.contains { $0.problemId == problem.id && $0.isCompleted }
    }
}
