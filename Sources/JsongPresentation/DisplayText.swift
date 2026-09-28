import JsongCore

// Text the learner sees for JsongCore values (Traditional Chinese). JsongCore
// keeps stable, untranslated identifiers; titles live here so they can be
// tested on Linux and changed without touching saved data.

extension KanaType {
    public var title: String {
        switch self {
        case .hiragana: return "平假名"
        case .katakana: return "片假名"
        }
    }
}

extension KanaGroup {
    public var title: String {
        switch self {
        case .vowels: return "母音"
        case .ka: return "か行"
        case .sa: return "さ行"
        case .ta: return "た行"
        case .na: return "な行"
        case .ha: return "は行"
        case .ma: return "ま行"
        case .ya: return "や行"
        case .ra: return "ら行"
        case .wa: return "わ行"
        case .n: return "ん"
        case .dakutenG: return "が行"
        case .dakutenZ: return "ざ行"
        case .dakutenD: return "だ行"
        case .dakutenB: return "ば行"
        case .handakutenP: return "ぱ行"
        case .comboK: return "きゃ行"
        case .comboS: return "しゃ行"
        case .comboT: return "ちゃ行"
        case .comboN: return "にゃ行"
        case .comboH: return "ひゃ行"
        case .comboM: return "みゃ行"
        case .comboR: return "りゃ行"
        case .comboG: return "ぎゃ行"
        case .comboZ: return "じゃ行"
        case .comboB: return "びゃ行"
        case .comboP: return "ぴゃ行"
        }
    }
}

extension KanaGroup.Kind {
    public var title: String {
        switch self {
        case .basic: return "基本"
        case .dakuten: return "濁音"
        case .combination: return "拗音"
        }
    }
}

extension VocabularyCategory {
    public var title: String {
        switch self {
        case .greetings: return "打招呼"
        case .numbers: return "數字"
        case .food: return "食物"
        case .animals: return "動物"
        case .family: return "家族"
        case .time: return "時間"
        case .colors: return "顏色"
        case .bodyParts: return "身體"
        case .dailyLife: return "日常生活"
        case .nature: return "自然"
        }
    }
}

extension QuizType {
    public var title: String {
        switch self {
        case .kanaToRomaji: return "假名 → 羅馬字"
        case .romajiToKana: return "羅馬字 → 假名"
        case .vocabMeaning: return "詞彙 → 意思"
        case .meaningToVocab: return "意思 → 詞彙"
        }
    }

    public var subtitle: String {
        switch self {
        case .kanaToRomaji: return "看假名選羅馬字"
        case .romajiToKana: return "看羅馬字選假名"
        case .vocabMeaning: return "看日文選中文意思"
        case .meaningToVocab: return "看中文選日文"
        }
    }
}

extension QuizGrade {
    public var title: String {
        switch self {
        case .excellent: return "優秀"
        case .good: return "良好"
        case .fair: return "加油"
        case .needsReview: return "需要複習"
        }
    }

    public var emoji: String {
        switch self {
        case .excellent: return "🎉"
        case .good: return "😊"
        case .fair: return "💪"
        case .needsReview: return "📚"
        }
    }
}

extension EchoPhase {
    public var title: String {
        switch self {
        case .see: return "看字"
        case .read: return "讀音"
        case .understand: return "理解"
        case .example: return "例句"
        case .recall: return "複習"
        }
    }

    public var instruction: String {
        switch self {
        case .see: return "仔細觀察這個詞 — 點擊繼續"
        case .read: return "記住它的讀音 — 點擊繼續"
        case .understand: return "理解它的意思 — 點擊繼續"
        case .example: return "看看如何在句子中使用 — 點擊繼續"
        case .recall: return "記得這個詞了嗎？"
        }
    }
}

public enum DisplayText {
    /// A 0…1 fraction as a whole percentage, rounded down so that "100%"
    /// means complete: "0%" … "100%".
    public static func percent(_ fraction: Double) -> String {
        let clamped = min(max(fraction, 0), 1)
        // The epsilon keeps values such as 29 / 100 (0.28999…×100) at 29.
        return "\(Int((clamped * 100 + 1e-9).rounded(.down)))%"
    }

    /// `learned` of `total` as a 0…1 fraction; 0 when `total` is 0.
    public static func fraction(_ learned: Int, of total: Int) -> Double {
        total > 0 ? Double(learned) / Double(total) : 0
    }
}
