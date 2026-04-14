import Foundation
import SwiftData

@Model
final class ProblemProgress {
    #Unique<ProblemProgress>([\.problemId])

    var problemId: String
    var categoryId: String
    var isCompleted: Bool
    var lastPlaybackPosition: Double
    var lastPlaybackSpeed: Float
    var lastListenedDate: Date?
    var listenCount: Int

    init(
        problemId: String,
        categoryId: String,
        isCompleted: Bool = false,
        lastPlaybackPosition: Double = 0,
        lastPlaybackSpeed: Float = 1.0,
        lastListenedDate: Date? = nil,
        listenCount: Int = 0
    ) {
        self.problemId = problemId
        self.categoryId = categoryId
        self.isCompleted = isCompleted
        self.lastPlaybackPosition = lastPlaybackPosition
        self.lastPlaybackSpeed = lastPlaybackSpeed
        self.lastListenedDate = lastListenedDate
        self.listenCount = listenCount
    }
}
