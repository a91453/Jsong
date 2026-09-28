/// The steps of the Echo Method: each word is revealed a little more at a
/// time, then the learner says whether they remember it.
public enum EchoPhase: Int, CaseIterable, Comparable, Sendable {
    /// Only the word.
    case see
    /// Adds the reading and romaji.
    case read
    /// Adds the meaning.
    case understand
    /// Adds the example sentence.
    case example
    /// The learner says whether they remember it.
    case recall

    public static func < (lhs: EchoPhase, rhs: EchoPhase) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

/// One Echo Method run over a few words.
public struct EchoSession: Hashable, Sendable {
    public let words: [VocabularyWord]
    /// Index of the word showing; equals `words.count` when finished.
    public private(set) var currentIndex = 0
    public private(set) var phase: EchoPhase = .see

    public init(words: [VocabularyWord]) {
        self.words = words
    }

    /// A run over `wordCount` random words from `pool`.
    public init<R: RandomNumberGenerator>(
        wordCount: Int,
        from pool: [VocabularyWord] = VocabularyData.all,
        using generator: inout R
    ) {
        precondition(wordCount >= 0, "wordCount must not be negative.")
        self.init(words: Array(pool.shuffled(using: &generator).prefix(wordCount)))
    }

    public var currentWord: VocabularyWord? {
        currentIndex < words.count ? words[currentIndex] : nil
    }

    public var isFinished: Bool { currentIndex >= words.count }

    /// Reveals the next step. Does nothing at `recall` or when finished.
    public mutating func advancePhase() {
        guard !isFinished, let next = EchoPhase(rawValue: phase.rawValue + 1) else { return }
        phase = next
    }

    /// At `recall`, moves on to the next word and returns the finished word
    /// if the learner remembered it (so it can be marked learned). Returns
    /// nil, changing nothing, before `recall` or when finished.
    @discardableResult
    public mutating func finishWord(remembered: Bool) -> VocabularyWord? {
        guard let word = currentWord, phase == .recall else { return nil }
        currentIndex += 1
        phase = .see
        return remembered ? word : nil
    }
}
