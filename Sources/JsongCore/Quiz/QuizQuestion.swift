import Foundation

/// The four multiple-choice quiz kinds. Raw values are stable identifiers
/// saved in the quiz history.
public enum QuizType: String, Codable, CaseIterable, Identifiable, Sendable {
    /// Kana shown, pick its romaji.
    case kanaToRomaji
    /// Romaji shown, pick the kana.
    case romajiToKana
    /// Japanese word shown, pick its meaning.
    case vocabMeaning
    /// Meaning shown, pick the Japanese word.
    case meaningToVocab

    public var id: String { rawValue }
}

/// One multiple-choice question.
public struct QuizQuestion: Hashable, Sendable {
    public let type: QuizType
    public let prompt: String
    public let answer: String
    /// The answer and its distractors in display order: unique, fixed when
    /// the question is made, and never containing another correct answer
    /// for the prompt.
    public let choices: [String]

    public init(type: QuizType, prompt: String, answer: String, choices: [String]) {
        precondition(choices.contains(answer), "The choices must contain the answer.")
        precondition(Set(choices).count == choices.count, "Choices must be unique.")
        self.type = type
        self.prompt = prompt
        self.answer = answer
        self.choices = choices
    }
}

/// How well a finished quiz went, from its share of correct answers.
public enum QuizGrade: String, Codable, CaseIterable, Sendable {
    /// 90 % or more.
    case excellent
    /// 70 % to under 90 %.
    case good
    /// 50 % to under 70 %.
    case fair
    /// Under 50 %.
    case needsReview
}

/// A finished quiz, as kept in the learner's history.
public struct QuizResult: Codable, Hashable, Sendable {
    public let date: Date
    public let type: QuizType
    /// Always at least 1.
    public let questionCount: Int
    /// From 0 to `questionCount`.
    public let correctCount: Int

    public init(date: Date, type: QuizType, questionCount: Int, correctCount: Int) {
        precondition(questionCount > 0, "A quiz result needs at least one question.")
        precondition((0...questionCount).contains(correctCount), "correctCount must be within 0...questionCount.")
        self.date = date
        self.type = type
        self.questionCount = questionCount
        self.correctCount = correctCount
    }

    private enum CodingKeys: String, CodingKey {
        case date, type, questionCount, correctCount
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let questionCount = try container.decode(Int.self, forKey: .questionCount)
        let correctCount = try container.decode(Int.self, forKey: .correctCount)
        guard questionCount > 0, (0...questionCount).contains(correctCount) else {
            throw DecodingError.dataCorruptedError(
                forKey: .correctCount,
                in: container,
                debugDescription: "Expected 0 <= correctCount <= questionCount and questionCount > 0."
            )
        }
        self.date = try container.decode(Date.self, forKey: .date)
        self.type = try container.decode(QuizType.self, forKey: .type)
        self.questionCount = questionCount
        self.correctCount = correctCount
    }

    /// Share of correct answers, 0…100.
    public var percentage: Double {
        Double(correctCount) * 100 / Double(questionCount)
    }

    public var grade: QuizGrade {
        // Integer comparisons, so a boundary such as 9 / 10 is exactly 90 %.
        let scaled = correctCount * 100
        if scaled >= 90 * questionCount { return .excellent }
        if scaled >= 70 * questionCount { return .good }
        if scaled >= 50 * questionCount { return .fair }
        return .needsReview
    }
}
