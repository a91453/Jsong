/// A vocabulary category. Raw values are stable identifiers; titles and
/// icons live in the presentation layers.
public enum VocabularyCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case greetings
    case numbers
    case food
    case animals
    case family
    case time
    case colors
    case bodyParts
    case dailyLife
    case nature

    public var id: String { rawValue }
}

public struct VocabularyWord: Identifiable, Codable, Hashable, Sendable {
    /// Stable identifier (`v_<romaji>`). Saved in progress.
    public let id: String
    public let japanese: String
    public let reading: String
    public let romaji: String
    /// Traditional Chinese meaning.
    public let meaning: String
    public let category: VocabularyCategory
    public let exampleSentence: String
    public let sentenceMeaning: String

    public init(
        id: String,
        japanese: String,
        reading: String,
        romaji: String,
        meaning: String,
        category: VocabularyCategory,
        exampleSentence: String,
        sentenceMeaning: String
    ) {
        self.id = id
        self.japanese = japanese
        self.reading = reading
        self.romaji = romaji
        self.meaning = meaning
        self.category = category
        self.exampleSentence = exampleSentence
        self.sentenceMeaning = sentenceMeaning
    }
}
