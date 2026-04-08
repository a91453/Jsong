import Foundation

enum VocabularyCategory: String, Codable, CaseIterable, Identifiable {
    case greetings = "打招呼"
    case numbers = "數字"
    case food = "食物"
    case animals = "動物"
    case family = "家族"
    case time = "時間"
    case colors = "顏色"
    case bodyParts = "身體"
    case dailyLife = "日常生活"
    case nature = "自然"

    var id: String { rawValue }

    var sfSymbol: String {
        switch self {
        case .greetings: return "hand.wave"
        case .numbers: return "number"
        case .food: return "fork.knife"
        case .animals: return "pawprint"
        case .family: return "person.3"
        case .time: return "clock"
        case .colors: return "paintpalette"
        case .bodyParts: return "figure.stand"
        case .dailyLife: return "house"
        case .nature: return "leaf"
        }
    }
}

struct VocabularyWord: Identifiable, Codable, Hashable {
    let id: String
    let japanese: String
    let reading: String
    let romaji: String
    let meaning: String
    let category: VocabularyCategory
    let exampleSentence: String
    let sentenceMeaning: String
}
