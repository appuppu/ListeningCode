import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            RoadmapView()
                .navigationDestination(for: LCCategory.self) { category in
                    ProblemListView(category: category)
                }
                .navigationDestination(for: LCProblem.self) { problem in
                    ProblemDetailView(problem: problem)
                }
        }
    }
}
