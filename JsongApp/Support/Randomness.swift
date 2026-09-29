import JsongCore

// New sessions with the system's random numbers. JsongCore takes a generator
// so that its tests can use a seeded one.

extension QuizSession {
    static func random(_ type: QuizType, questionCount: Int = 10) -> QuizSession {
        var generator = SystemRandomNumberGenerator()
        return QuizSession(type: type, questionCount: questionCount, using: &generator)
    }
}

extension EchoSession {
    static func random(wordCount: Int = 10) -> EchoSession {
        var generator = SystemRandomNumberGenerator()
        return EchoSession(wordCount: wordCount, using: &generator)
    }
}

extension MatchingGame {
    /// Pairs drawn from the 46 basic hiragana.
    static func randomBasicHiragana(pairCount: Int = 6) -> MatchingGame {
        var generator = SystemRandomNumberGenerator()
        let kana = HiraganaData.all.filter { $0.group.kind == .basic }
        return MatchingGame(kana: kana, pairCount: pairCount, using: &generator)
    }
}
