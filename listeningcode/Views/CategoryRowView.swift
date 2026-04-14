import SwiftUI

struct CategoryRowView: View {
    let category: LCCategory
    let completedCount: Int

    private var progress: Double {
        guard category.problemCount > 0 else { return 0 }
        return Double(completedCount) / Double(category.problemCount)
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.systemImage)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 6) {
                Text(category.title)
                    .font(.headline)

                HStack(spacing: 8) {
                    ProgressView(value: progress)
                        .tint(progress >= 1.0 ? .green : .accentColor)

                    Text("\(completedCount)/\(category.problemCount)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .padding(.vertical, 4)
    }
}
