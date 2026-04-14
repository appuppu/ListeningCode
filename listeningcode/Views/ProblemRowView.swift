import SwiftUI

struct ProblemRowView: View {
    let problem: LCProblem
    let categoryNumber: Int
    let isCompleted: Bool
    var isLocked: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(categoryNumber)-\(problem.sectionNumber). \(problem.title)")
                    .font(.headline)
                    .foregroundStyle(isLocked ? .secondary : .primary)

                DifficultyBadge(difficulty: problem.difficulty)
            }

            Spacer()

            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            } else if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DifficultyBadge: View {
    let difficulty: LCProblem.Difficulty

    private var color: Color {
        switch difficulty {
        case .easy: .green
        case .medium: .orange
        case .hard: .red
        }
    }

    var body: some View {
        Text(difficulty.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.15), in: Capsule())
    }
}
