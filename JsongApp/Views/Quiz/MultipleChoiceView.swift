import JsongCore
import JsongPresentation
import SwiftUI

struct MultipleChoiceView: View {
    let quizType: QuizType
    @Environment(ProgressStore.self) private var store
    @State private var session: QuizSession
    /// Set, and saved to the history, once the last question is answered.
    @State private var result: QuizResult?

    init(quizType: QuizType) {
        self.quizType = quizType
        _session = State(initialValue: .random(quizType))
    }

    var body: some View {
        VStack(spacing: 20) {
            if let result {
                QuizResultView(result: result) {
                    session = .random(quizType)
                    self.result = nil
                }
            } else if let question = session.currentQuestion {
                VStack(spacing: 8) {
                    HStack {
                        Text("第 \(session.currentIndex + 1) / \(session.questions.count) 題")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Label("\(session.correctCount)", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(Color.jsongMint)
                    }
                    ProgressView(value: session.progress)
                        .tint(.quizColor)
                }
                .padding(.horizontal)

                Spacer()

                VStack(spacing: 12) {
                    Text("請選擇正確答案")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(question.prompt)
                        .font(.system(size: isLargePrompt ? 100 : 40, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.4)
                        .padding(.horizontal)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal)

                Spacer()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(question.choices, id: \.self) { choice in
                        AnswerButton(
                            text: choice,
                            isSelected: session.selectedChoice == choice,
                            isCorrect: choice == question.answer,
                            showResult: session.isAnswered,
                            fontSize: isLargeAnswer ? 32 : 18
                        ) {
                            answer(choice)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(quizType.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isLargePrompt: Bool {
        quizType == .kanaToRomaji || quizType == .vocabMeaning
    }

    private var isLargeAnswer: Bool {
        quizType == .romajiToKana || quizType == .meaningToVocab
    }

    /// Shows whether the pick was right, then moves on after a moment; after
    /// the last question the result is saved once.
    private func answer(_ choice: String) {
        guard session.answer(choice) != nil else { return }
        Task {
            try? await Task.sleep(for: .milliseconds(1200))
            withAnimation {
                session.advance()
                if result == nil, let finished = session.result(on: .now) {
                    store.recordQuiz(finished)
                    result = finished
                }
            }
        }
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
                .foregroundStyle(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
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
                                .foregroundStyle(Color.jsongMint)
                                .background(Circle().fill(Color.white))
                                .padding(6)
                        } else if isSelected {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.jsongRed)
                                .background(Circle().fill(Color.white))
                                .padding(6)
                        }
                    }
                }
        }
        .disabled(showResult)
    }

    private var backgroundColor: Color {
        if !showResult { return Color(.systemBackground) }
        if isCorrect { return .jsongMint.opacity(0.2) }
        if isSelected { return .jsongRed.opacity(0.15) }
        return Color(.systemBackground)
    }

    private var borderColor: Color {
        if !showResult { return Color(.systemGray4) }
        if isCorrect { return .jsongMint }
        if isSelected { return .jsongRed }
        return Color(.systemGray4)
    }

    private var textColor: Color {
        if !showResult { return .primary }
        if isCorrect { return .jsongMint }
        if isSelected { return .jsongRed }
        return .primary
    }
}
