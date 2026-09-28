/// Builds multiple-choice questions from the built-in kana and vocabulary.
public enum QuizGenerator {
    /// Choices per question: the answer and up to three distractors.
    public static let choiceCount = 4

    /// A prompt and one correct answer for it.
    public struct Item: Hashable, Sendable {
        public let prompt: String
        public let answer: String

        public init(prompt: String, answer: String) {
            self.prompt = prompt
            self.answer = answer
        }
    }

    /// Every prompt–answer pair the quiz type draws from.
    ///
    /// A prompt can have several correct answers: romaji "ka" is both か and
    /// カ, and 月 means both 月份 and 月亮.
    public static func items(for type: QuizType) -> [Item] {
        switch type {
        case .kanaToRomaji:
            return KanaData.all.map { Item(prompt: $0.character, answer: $0.romaji) }
        case .romajiToKana:
            return KanaData.all.map { Item(prompt: $0.romaji, answer: $0.character) }
        case .vocabMeaning:
            return VocabularyData.all.map { Item(prompt: $0.japanese, answer: $0.meaning) }
        case .meaningToVocab:
            return VocabularyData.all.map { Item(prompt: $0.meaning, answer: $0.japanese) }
        }
    }

    /// Up to `count` questions with distinct prompts.
    ///
    /// Distractors are answers of other items that are not correct for the
    /// prompt, so a question never offers two right answers. The result
    /// depends only on the items and the generator's output.
    public static func questions<R: RandomNumberGenerator>(
        for type: QuizType,
        count: Int,
        using generator: inout R
    ) -> [QuizQuestion] {
        questions(for: type, from: items(for: type), count: count, using: &generator)
    }

    /// Same as `questions(for:count:using:)` for an explicit item list.
    public static func questions<R: RandomNumberGenerator>(
        for type: QuizType,
        from items: [Item],
        count: Int,
        using generator: inout R
    ) -> [QuizQuestion] {
        precondition(count >= 0, "count must not be negative.")
        let pool = items.shuffled(using: &generator)
        var questions: [QuizQuestion] = []
        var usedPrompts: Set<String> = []

        for item in pool {
            guard questions.count < count else { break }
            guard usedPrompts.insert(item.prompt).inserted else { continue }

            let correct = Set(pool.lazy.filter { $0.prompt == item.prompt }.map(\.answer))
            var distractors: [String] = []
            var seen = correct
            // Reshuffled per question; walking `pool` itself would give
            // every question the same distractors.
            for candidate in pool.shuffled(using: &generator) where distractors.count < choiceCount - 1 {
                if seen.insert(candidate.answer).inserted {
                    distractors.append(candidate.answer)
                }
            }
            let choices = (distractors + [item.answer]).shuffled(using: &generator)
            questions.append(QuizQuestion(type: type, prompt: item.prompt, answer: item.answer, choices: choices))
        }
        return questions
    }
}
