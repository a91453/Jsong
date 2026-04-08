import SwiftUI

class ProgressManager: ObservableObject {
    @AppStorage("userProgressData") private var progressJSON: String = ""

    @Published var progress: UserProgress {
        didSet { save() }
    }

    init() {
        if let data = UserDefaults.standard.string(forKey: "userProgressData")?.data(using: .utf8),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            progress = decoded
        } else {
            progress = .empty
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(progress),
           let json = String(data: data, encoding: .utf8) {
            progressJSON = json
        }
    }

    // MARK: - Kana Progress

    func markKanaLearned(_ id: String) {
        progress.learnedKanaIDs.insert(id)
        updateStreak()
    }

    func isKanaLearned(_ id: String) -> Bool {
        progress.learnedKanaIDs.contains(id)
    }

    func toggleKanaLearned(_ id: String) {
        if progress.learnedKanaIDs.contains(id) {
            progress.learnedKanaIDs.remove(id)
        } else {
            progress.learnedKanaIDs.insert(id)
            updateStreak()
        }
    }

    // MARK: - Vocabulary Progress

    func markVocabLearned(_ id: String) {
        progress.learnedVocabIDs.insert(id)
        updateStreak()
    }

    func isVocabLearned(_ id: String) -> Bool {
        progress.learnedVocabIDs.contains(id)
    }

    func toggleVocabLearned(_ id: String) {
        if progress.learnedVocabIDs.contains(id) {
            progress.learnedVocabIDs.remove(id)
        } else {
            progress.learnedVocabIDs.insert(id)
            updateStreak()
        }
    }

    // MARK: - Quiz

    func recordQuizResult(_ result: QuizResult) {
        progress.quizHistory.append(result)
        progress.totalStudySessions += 1
        updateStreak()
    }

    // MARK: - Streak

    private func updateStreak() {
        let today = Self.dateString(from: Date())
        if progress.lastStudyDate == today {
            return
        }

        let yesterday = Self.dateString(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        if progress.lastStudyDate == yesterday {
            progress.dailyStreak += 1
        } else if progress.lastStudyDate != today {
            progress.dailyStreak = 1
        }
        progress.lastStudyDate = today
    }

    private static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Computed Stats

    var hiraganaProgress: Double {
        let total = Double(HiraganaData.all.count)
        guard total > 0 else { return 0 }
        let learned = Double(progress.learnedKanaIDs.filter { $0.hasPrefix("hira_") }.count)
        return learned / total
    }

    var katakanaProgress: Double {
        let total = Double(KatakanaData.all.count)
        guard total > 0 else { return 0 }
        let learned = Double(progress.learnedKanaIDs.filter { $0.hasPrefix("kata_") }.count)
        return learned / total
    }

    var vocabProgress: Double {
        let total = Double(VocabularyData.all.count)
        guard total > 0 else { return 0 }
        let learned = Double(progress.learnedVocabIDs.count)
        return learned / total
    }

    var averageQuizScore: Double {
        guard !progress.quizHistory.isEmpty else { return 0 }
        let total = progress.quizHistory.reduce(0.0) { $0 + $1.percentage }
        return total / Double(progress.quizHistory.count)
    }

    var recentQuizzes: [QuizResult] {
        Array(progress.quizHistory.suffix(10).reversed())
    }
}
