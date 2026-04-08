import Foundation

enum QuizType: String, Codable, CaseIterable, Identifiable {
    case kanaToRomaji = "假名 → 羅馬字"
    case romajiToKana = "羅馬字 → 假名"
    case vocabMeaning = "詞彙 → 意思"
    case meaningToVocab = "意思 → 詞彙"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .kanaToRomaji: return "看假名選羅馬字"
        case .romajiToKana: return "看羅馬字選假名"
        case .vocabMeaning: return "看日文選中文意思"
        case .meaningToVocab: return "看中文選日文"
        }
    }

    var sfSymbol: String {
        switch self {
        case .kanaToRomaji: return "character.ja"
        case .romajiToKana: return "textformat.abc"
        case .vocabMeaning: return "text.book.closed"
        case .meaningToVocab: return "character.book.closed"
        }
    }
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let correctAnswer: String
    let wrongAnswers: [String]
    let type: QuizType

    var allAnswers: [String] {
        (wrongAnswers + [correctAnswer]).shuffled()
    }
}

struct QuizResult: Identifiable, Codable {
    let id: String
    let date: Date
    let quizType: QuizType
    let totalQuestions: Int
    let correctAnswers: Int

    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions) * 100
    }

    var grade: String {
        switch percentage {
        case 90...100: return "優秀"
        case 70..<90: return "良好"
        case 50..<70: return "加油"
        default: return "需要複習"
        }
    }
}
