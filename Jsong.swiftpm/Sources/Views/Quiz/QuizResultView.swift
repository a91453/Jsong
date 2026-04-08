import SwiftUI

struct QuizResultView: View {
    let result: QuizResult
    let onRetry: () -> Void
    @Environment(\.dismiss) private var dismiss

    var emoji: String {
        switch result.percentage {
        case 90...100: return "🎉"
        case 70..<90: return "😊"
        case 50..<70: return "💪"
        default: return "📚"
        }
    }

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text(emoji)
                .font(.system(size: 80))

            VStack(spacing: 8) {
                Text(result.grade)
                    .font(.largeTitle.bold())
                    .foregroundColor(.quizColor)
                Text("你完成了這次測驗")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Score circle
            ZStack {
                Circle()
                    .stroke(Color.quizColor.opacity(0.2), lineWidth: 16)
                    .frame(width: 180, height: 180)

                Circle()
                    .trim(from: 0, to: CGFloat(result.percentage / 100))
                    .stroke(Color.quizColor, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 180, height: 180)
                    .animation(.easeInOut(duration: 0.8), value: result.percentage)

                VStack(spacing: 4) {
                    Text("\(result.correctAnswers)/\(result.totalQuestions)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("\(Int(result.percentage))%")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }

            VStack(spacing: 12) {
                InfoRow(label: "測驗類型", value: result.quizType.rawValue)
                InfoRow(label: "答對題數", value: "\(result.correctAnswers) 題")
                InfoRow(label: "答錯題數", value: "\(result.totalQuestions - result.correctAnswers) 題")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Label("返回", systemImage: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.quizColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.quizColor.opacity(0.15))
                        )
                }

                Button {
                    onRetry()
                } label: {
                    Label("再測一次", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.quizColor)
                        )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
