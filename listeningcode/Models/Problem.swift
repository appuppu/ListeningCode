import Foundation

struct LCProblem: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let difficulty: Difficulty
    let sortOrder: Int
    let contentFile: String
    let leetcodeUrl: String?

    /// Section number within category (1-based, derived from sortOrder)
    var sectionNumber: Int { sortOrder + 1 }

    /// First 2 problems per category are free
    var isFree: Bool { sortOrder < 2 }

    enum Difficulty: String, Codable {
        case easy, medium, hard

        var displayName: String {
            rawValue.capitalized
        }

        var color: String {
            switch self {
            case .easy: "green"
            case .medium: "orange"
            case .hard: "red"
            }
        }
    }
}
