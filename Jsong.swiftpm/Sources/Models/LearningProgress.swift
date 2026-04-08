import Foundation

struct UserProgress: Codable {
    var learnedKanaIDs: Set<String>
    var learnedVocabIDs: Set<String>
    var quizHistory: [QuizResult]
    var dailyStreak: Int
    var lastStudyDate: String
    var totalStudySessions: Int

    static let empty = UserProgress(
        learnedKanaIDs: [],
        learnedVocabIDs: [],
        quizHistory: [],
        dailyStreak: 0,
        lastStudyDate: "",
        totalStudySessions: 0
    )
}
