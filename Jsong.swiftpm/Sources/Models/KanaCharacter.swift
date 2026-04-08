import Foundation

enum KanaType: String, Codable, CaseIterable {
    case hiragana = "平假名"
    case katakana = "片假名"
}

enum KanaGroup: String, Codable, CaseIterable, Identifiable {
    case vowels = "母音"
    case ka = "か行"
    case sa = "さ行"
    case ta = "た行"
    case na = "な行"
    case ha = "は行"
    case ma = "ま行"
    case ya = "や行"
    case ra = "ら行"
    case wa = "わ行"
    case n = "ん"
    case dakutenG = "が行"
    case dakutenZ = "ざ行"
    case dakutenD = "だ行"
    case dakutenB = "ば行"
    case handakutenP = "ぱ行"
    case comboK = "きゃ行"
    case comboS = "しゃ行"
    case comboT = "ちゃ行"
    case comboN = "にゃ行"
    case comboH = "ひゃ行"
    case comboM = "みゃ行"
    case comboR = "りゃ行"
    case comboG = "ぎゃ行"
    case comboZ = "じゃ行"
    case comboB = "びゃ行"
    case comboP = "ぴゃ行"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var isBasic: Bool {
        switch self {
        case .vowels, .ka, .sa, .ta, .na, .ha, .ma, .ya, .ra, .wa, .n:
            return true
        default:
            return false
        }
    }

    var isDakuten: Bool {
        switch self {
        case .dakutenG, .dakutenZ, .dakutenD, .dakutenB, .handakutenP:
            return true
        default:
            return false
        }
    }

    var isCombo: Bool {
        switch self {
        case .comboK, .comboS, .comboT, .comboN, .comboH, .comboM, .comboR,
             .comboG, .comboZ, .comboB, .comboP:
            return true
        default:
            return false
        }
    }
}

struct KanaCharacter: Identifiable, Codable, Hashable {
    let id: String
    let character: String
    let romaji: String
    let type: KanaType
    let group: KanaGroup
    let strokeCount: Int
    let mnemonicHint: String
}
