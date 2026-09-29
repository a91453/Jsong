import Foundation

/// The state of one quiz run: which question is showing, what was picked,
/// and the score.
public struct QuizSession: Hashable, Sendable {
    public let type: QuizType
    public let questions: [QuizQuestion]
    /// Index of the question showing; equals `questions.count` when finished.
    public private(set) var currentIndex = 0
    public private(set) var correctCount = 0
    /// The choice picked for the current question; nil until it is answered.
    public private(set) var selectedChoice: String?

    public init(type: QuizType, questions: [QuizQuestion]) {
        precondition(questions.allSatisfy { $0.type == type }, "Every question must be of the session's type.")
        self.type = type
        self.questions = questions
    }

    /// A new run of `questionCount` random questions.
    public init<R: RandomNumberGenerator>(type: QuizType, questionCount: Int, using generator: inout R) {
        self.init(type: type, questions: QuizGenerator.questions(for: type, count: questionCount, using: &generator))
    }

    public var currentQuestion: QuizQuestion? {
        currentIndex < questions.count ? questions[currentIndex] : nil
    }

    public var isFinished: Bool { currentIndex >= questions.count }

    /// Whether the current question has been answered.
    public var isAnswered: Bool { selectedChoice != nil }

    /// Share of questions already moved past, 0…1.
    public var progress: Double {
        questions.isEmpty ? 1 : Double(currentIndex) / Double(questions.count)
    }

    /// Picks `choice` for the current question and returns whether it is
    /// correct.
    ///
    /// Returns nil and changes nothing when the quiz is finished, the
    /// question is already answered, or `choice` is not one of its choices.
    @discardableResult
    public mutating func answer(_ choice: String) -> Bool? {
        guard let question = currentQuestion, selectedChoice == nil, question.choices.contains(choice) else {
            return nil
        }
        selectedChoice = choice
        let isCorrect = choice == question.answer
        if isCorrect {
            correctCount += 1
        }
        return isCorrect
    }

    /// Moves past the current question once it is answered; otherwise does
    /// nothing.
    public mutating func advance() {
        guard !isFinished, selectedChoice != nil else { return }
        selectedChoice = nil
        currentIndex += 1
    }

    /// The result to keep, once every question is answered. Nil before that,
    /// and for a quiz without questions.
    public func result(on date: Date) -> QuizResult? {
        guard isFinished, !questions.isEmpty else { return nil }
        return QuizResult(date: date, type: type, questionCount: questions.count, correctCount: correctCount)
    }
}
