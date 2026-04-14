import Foundation

struct LCCategory: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let systemImage: String
    let problemCount: Int
    let sortOrder: Int
}
