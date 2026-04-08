import SwiftUI

class QuizEngine: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var score: Int = 0
    @Published var selectedAnswer: String? = nil
    @Published var isCorrect: Bool? = nil
    @Published var isFinished: Bool = false

    let quizType: QuizType
    let questionCount: Int

    init(quizType: QuizType, questionCount: Int = 10) {
        self.quizType = quizType
        self.questionCount = questionCount
        generateQuestions()
    }

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progressFraction: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    func generateQuestions() {
        var generated: [QuizQuestion] = []

        switch quizType {
        case .kanaToRomaji:
            let allKana = (HiraganaData.all + KatakanaData.all).shuffled()
            let selected = Array(allKana.prefix(questionCount))
            for kana in selected {
                let distractors = allKana
                    .filter { $0.romaji != kana.romaji }
                    .map { $0.romaji }
                    .shuffled()
                let wrongAnswers = Array(Set(Array(distractors.prefix(3))))
                let padded = wrongAnswers.count < 3
                    ? wrongAnswers + Array(repeating: wrongAnswers.first ?? "", count: 3 - wrongAnswers.count)
                    : wrongAnswers
                generated.append(QuizQuestion(
                    prompt: kana.character,
                    correctAnswer: kana.romaji,
                    wrongAnswers: Array(padded.prefix(3)),
                    type: .kanaToRomaji
                ))
            }

        case .romajiToKana:
            let allKana = (HiraganaData.all + KatakanaData.all).shuffled()
            let selected = Array(allKana.prefix(questionCount))
            for kana in selected {
                let distractors = allKana
                    .filter { $0.character != kana.character }
                    .map { $0.character }
                    .shuffled()
                let wrongAnswers = Array(Set(Array(distractors.prefix(3))))
                let padded = wrongAnswers.count < 3
                    ? wrongAnswers + Array(repeating: wrongAnswers.first ?? "", count: 3 - wrongAnswers.count)
                    : wrongAnswers
                generated.append(QuizQuestion(
                    prompt: kana.romaji,
                    correctAnswer: kana.character,
                    wrongAnswers: Array(padded.prefix(3)),
                    type: .romajiToKana
                ))
            }

        case .vocabMeaning:
            let allVocab = VocabularyData.all.shuffled()
            let selected = Array(allVocab.prefix(questionCount))
            for word in selected {
                let distractors = allVocab
                    .filter { $0.meaning != word.meaning }
                    .map { $0.meaning }
                    .shuffled()
                let wrongAnswers = Array(Set(Array(distractors.prefix(3))))
                let padded = wrongAnswers.count < 3
                    ? wrongAnswers + Array(repeating: wrongAnswers.first ?? "", count: 3 - wrongAnswers.count)
                    : wrongAnswers
                generated.append(QuizQuestion(
                    prompt: word.japanese,
                    correctAnswer: word.meaning,
                    wrongAnswers: Array(padded.prefix(3)),
                    type: .vocabMeaning
                ))
            }

        case .meaningToVocab:
            let allVocab = VocabularyData.all.shuffled()
            let selected = Array(allVocab.prefix(questionCount))
            for word in selected {
                let distractors = allVocab
                    .filter { $0.japanese != word.japanese }
                    .map { $0.japanese }
                    .shuffled()
                let wrongAnswers = Array(Set(Array(distractors.prefix(3))))
                let padded = wrongAnswers.count < 3
                    ? wrongAnswers + Array(repeating: wrongAnswers.first ?? "", count: 3 - wrongAnswers.count)
                    : wrongAnswers
                generated.append(QuizQuestion(
                    prompt: word.meaning,
                    correctAnswer: word.japanese,
                    wrongAnswers: Array(padded.prefix(3)),
                    type: .meaningToVocab
                ))
            }
        }

        questions = generated
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        isCorrect = nil
        isFinished = false
    }

    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        selectedAnswer = answer
        isCorrect = answer == question.correctAnswer
        if isCorrect == true {
            score += 1
        }
    }

    func nextQuestion() {
        selectedAnswer = nil
        isCorrect = nil
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            isFinished = true
        }
    }

    func buildResult() -> QuizResult {
        QuizResult(
            id: UUID().uuidString,
            date: Date(),
            quizType: quizType,
            totalQuestions: questions.count,
            correctAnswers: score
        )
    }
}
