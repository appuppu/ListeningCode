import SwiftUI
import SwiftData

struct RoadmapView: View {
    @Query private var allProgress: [ProblemProgress]
    private let categories = ContentLoader.loadCategories()

    var body: some View {
        List {
            ForEach(categories.sorted(by: { $0.sortOrder < $1.sortOrder })) { category in
                NavigationLink(value: category) {
                    CategoryRowView(
                        category: category,
                        completedCount: completedCount(for: category)
                    )
                }
            }
        }
        .navigationTitle("Roadmap")
    }

    private func completedCount(for category: LCCategory) -> Int {
        allProgress.filter { $0.categoryId == category.id && $0.isCompleted }.count
    }
}
