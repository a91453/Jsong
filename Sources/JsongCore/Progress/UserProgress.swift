/// Everything the app remembers about the learner: learned kana and words,
/// finished quizzes, and the daily study streak.
///
/// A value type changed only through its methods; each method that counts as
/// studying takes the day it happened on, so streak rules never read a clock.
public struct UserProgress: Hashable, Sendable {
    public private(set) var learnedKanaIDs: Set<String> = []
    public private(set) var learnedVocabularyIDs: Set<String> = []
    /// Oldest first.
    public private(set) var quizHistory: [QuizResult] = []
    /// Consecutive study days ending at `lastStudyDay`; 0 exactly when
    /// `lastStudyDay` is nil.
    public private(set) var streak = 0
    public private(set) var lastStudyDay: StudyDay?

    public init() {}

    public func isKanaLearned(_ id: String) -> Bool {
        learnedKanaIDs.contains(id)
    }

    public func isVocabularyLearned(_ id: String) -> Bool {
        learnedVocabularyIDs.contains(id)
    }

    /// Marks a kana learned or not. Marking it learned counts as studying
    /// on `day`.
    public mutating func setKana(_ id: String, learned: Bool, on day: StudyDay) {
        if learned {
            learnedKanaIDs.insert(id)
            recordStudy(on: day)
        } else {
            learnedKanaIDs.remove(id)
        }
    }

    /// Marks a word learned or not. Marking it learned counts as studying
    /// on `day`.
    public mutating func setVocabulary(_ id: String, learned: Bool, on day: StudyDay) {
        if learned {
            learnedVocabularyIDs.insert(id)
            recordStudy(on: day)
        } else {
            learnedVocabularyIDs.remove(id)
        }
    }

    /// Adds a finished quiz to the history; counts as studying on `day`.
    public mutating func recordQuiz(_ result: QuizResult, on day: StudyDay) {
        quizHistory.append(result)
        recordStudy(on: day)
    }

    /// Extends the streak if `day` follows the last study day, keeps it on
    /// the same day, and restarts it at 1 after a gap. A day before the last
    /// study day (the device clock moved back) changes nothing.
    public mutating func recordStudy(on day: StudyDay) {
        guard let last = lastStudyDay else {
            streak = 1
            lastStudyDay = day
            return
        }
        switch day.dayNumber - last.dayNumber {
        case ..<0, 0:
            return
        case 1:
            streak += 1
        default:
            streak = 1
        }
        lastStudyDay = day
    }

    /// The streak as of `today`: it still counts if the learner studied
    /// today or yesterday, and is 0 after a missed day.
    public func currentStreak(on today: StudyDay) -> Int {
        guard let last = lastStudyDay else { return 0 }
        let gap = today.dayNumber - last.dayNumber
        return gap <= 1 ? streak : 0
    }

    /// How many of `kana` are learned. IDs no longer in the built-in data
    /// are not counted.
    public func learnedCount(of kana: [KanaCharacter]) -> Int {
        kana.lazy.filter { learnedKanaIDs.contains($0.id) }.count
    }

    /// How many of `words` are learned.
    public func learnedCount(of words: [VocabularyWord]) -> Int {
        words.lazy.filter { learnedVocabularyIDs.contains($0.id) }.count
    }

    /// Mean percentage of all finished quizzes; nil without any.
    public var averageQuizPercentage: Double? {
        guard !quizHistory.isEmpty else { return nil }
        return quizHistory.reduce(0) { $0 + $1.percentage } / Double(quizHistory.count)
    }

    /// The latest quizzes, newest first.
    public func recentQuizzes(limit: Int) -> [QuizResult] {
        precondition(limit >= 0, "limit must not be negative.")
        return Array(quizHistory.suffix(limit).reversed())
    }
}

extension UserProgress: Codable {
    private enum CodingKeys: String, CodingKey {
        case learnedKanaIDs, learnedVocabularyIDs, quizHistory, streak, lastStudyDay
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let streak = try container.decode(Int.self, forKey: .streak)
        let lastStudyDay = try container.decodeIfPresent(StudyDay.self, forKey: .lastStudyDay)
        guard lastStudyDay == nil ? streak == 0 : streak >= 1 else {
            throw DecodingError.dataCorruptedError(
                forKey: .streak,
                in: container,
                debugDescription: "streak must be 0 without a last study day and at least 1 with one."
            )
        }
        self.learnedKanaIDs = Set(try container.decode([String].self, forKey: .learnedKanaIDs))
        self.learnedVocabularyIDs = Set(try container.decode([String].self, forKey: .learnedVocabularyIDs))
        self.quizHistory = try container.decode([QuizResult].self, forKey: .quizHistory)
        self.streak = streak
        self.lastStudyDay = lastStudyDay
    }

    /// Sets are written as sorted arrays so the same progress always encodes
    /// to the same bytes.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(learnedKanaIDs.sorted(), forKey: .learnedKanaIDs)
        try container.encode(learnedVocabularyIDs.sorted(), forKey: .learnedVocabularyIDs)
        try container.encode(quizHistory, forKey: .quizHistory)
        try container.encode(streak, forKey: .streak)
        try container.encodeIfPresent(lastStudyDay, forKey: .lastStudyDay)
    }
}
