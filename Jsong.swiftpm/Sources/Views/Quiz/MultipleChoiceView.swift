import SwiftUI

struct MultipleChoiceView: View {
    let quizType: QuizType
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var engine: QuizEngine
    @State private var showResult = false

    init(quizType: QuizType) {
        self.quizType = quizType
        _engine = StateObject(wrappedValue: QuizEngine(quizType: quizType, questionCount: 10))
    }

    var body: some View {
        VStack(spacing: 20) {
            if engine.isFinished {
                QuizResultView(
                    result: engine.buildResult(),
                    onRetry: {
                        engine.generateQuestions()
                    }
                )
            } else if let question = engine.currentQuestion {
                // Progress
                VStack(spacing: 8) {
                    HStack {
                        Text("第 \(engine.currentIndex + 1) / \(engine.questions.count) 題")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Label("\(engine.score)", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(.jsongMint)
                    }
                    ProgressView(value: engine.progressFraction)
                        .tint(.quizColor)
                }
                .padding(.horizontal)

                Spacer()

                // Question
                VStack(spacing: 12) {
                    Text("請選擇正確答案")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(question.prompt)
                        .font(.system(size: isLargePrompt ? 100 : 40, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal)

                Spacer()

                // Answers
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(question.allAnswers, id: \.self) { answer in
                        AnswerButton(
                            text: answer,
                            isSelected: engine.selectedAnswer == answer,
                            isCorrect: answer == question.correctAnswer,
                            showResult: engine.selectedAnswer != nil,
                            fontSize: isLargeAnswer ? 32 : 18
                        ) {
                            if engine.selectedAnswer == nil {
                                engine.submitAnswer(answer)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    withAnimation {
                                        engine.nextQuestion()
                                        if engine.isFinished {
                                            progressManager.recordQuizResult(engine.buildResult())
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(quizType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }

    var isLargePrompt: Bool {
        quizType == .kanaToRomaji || quizType == .vocabMeaning
    }

    var isLargeAnswer: Bool {
        quizType == .romajiToKana || quizType == .meaningToVocab
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let fontSize: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 70)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(backgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor, lineWidth: 2)
                )
                .overlay(alignment: .topTrailing) {
                    if showResult {
                        if isCorrect {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.jsongMint)
                                .background(Circle().fill(Color.white))
                                .padding(6)
                        } else if isSelected {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.jsongRed)
                                .background(Circle().fill(Color.white))
                                .padding(6)
                        }
                    }
                }
        }
        .disabled(showResult)
    }

    var backgroundColor: Color {
        if !showResult { return Color(.systemBackground) }
        if isCorrect { return .jsongMint.opacity(0.2) }
        if isSelected { return .jsongRed.opacity(0.15) }
        return Color(.systemBackground)
    }

    var borderColor: Color {
        if !showResult { return Color(.systemGray4) }
        if isCorrect { return .jsongMint }
        if isSelected { return .jsongRed }
        return Color(.systemGray4)
    }

    var textColor: Color {
        if !showResult { return .primary }
        if isCorrect { return .jsongMint }
        if isSelected { return .jsongRed }
        return .primary
    }
}
