/// The two kana scripts.
///
/// Raw values are stable identifiers (they may be saved); the text shown to
/// the learner lives in JsongPresentation's `DisplayText`.
public enum KanaType: String, Codable, CaseIterable, Sendable {
    case hiragana
    case katakana
}

/// A row of the kana table (basic rows, rows with (han)dakuten, and yōon
/// combinations). Declaration order is the table order.
public enum KanaGroup: String, Codable, CaseIterable, Identifiable, Sendable {
    case vowels
    case ka
    case sa
    case ta
    case na
    case ha
    case ma
    case ya
    case ra
    case wa
    case n
    case dakutenG
    case dakutenZ
    case dakutenD
    case dakutenB
    case handakutenP
    case comboK
    case comboS
    case comboT
    case comboN
    case comboH
    case comboM
    case comboR
    case comboG
    case comboZ
    case comboB
    case comboP

    public var id: String { rawValue }

    /// Which part of the table the row belongs to.
    public var kind: Kind {
        switch self {
        case .vowels, .ka, .sa, .ta, .na, .ha, .ma, .ya, .ra, .wa, .n:
            return .basic
        case .dakutenG, .dakutenZ, .dakutenD, .dakutenB, .handakutenP:
            return .dakuten
        case .comboK, .comboS, .comboT, .comboN, .comboH, .comboM, .comboR,
             .comboG, .comboZ, .comboB, .comboP:
            return .combination
        }
    }

    public enum Kind: String, Codable, CaseIterable, Sendable {
        /// The 46 basic kana (seion and ん).
        case basic
        /// Kana with dakuten or handakuten.
        case dakuten
        /// Yōon: a kana followed by a small ゃ, ゅ or ょ.
        case combination
    }
}

public struct KanaCharacter: Identifiable, Codable, Hashable, Sendable {
    /// Stable identifier, `hira_<romaji>` or `kata_<romaji>`. Saved in progress.
    public let id: String
    public let character: String
    public let romaji: String
    public let type: KanaType
    public let group: KanaGroup
    public let strokeCount: Int
    public let mnemonicHint: String

    public init(
        id: String,
        character: String,
        romaji: String,
        type: KanaType,
        group: KanaGroup,
        strokeCount: Int,
        mnemonicHint: String
    ) {
        self.id = id
        self.character = character
        self.romaji = romaji
        self.type = type
        self.group = group
        self.strokeCount = strokeCount
        self.mnemonicHint = mnemonicHint
    }
}

public enum KanaData {
    /// All kana of one script, in table order.
    public static func characters(of type: KanaType) -> [KanaCharacter] {
        switch type {
        case .hiragana: return HiraganaData.all
        case .katakana: return KatakanaData.all
        }
    }

    /// Hiragana followed by katakana.
    public static let all: [KanaCharacter] = HiraganaData.all + KatakanaData.all
}
