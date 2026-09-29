import JsongCore
import JsongPresentation
import SwiftUI

struct QuizResultView: View {
    let result: QuizResult
    let onRetry: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text(result.grade.emoji)
                .font(.system(size: 80))

            VStack(spacing: 8) {
                Text(result.grade.title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.quizColor)
                Text("你完成了這次測驗")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

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
                    Text("\(result.correctCount)/\(result.questionCount)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text(DisplayText.percent(result.percentage / 100))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 12) {
                InfoRow(label: "測驗類型", value: result.type.title)
                InfoRow(label: "答對題數", value: "\(result.correctCount) 題")
                InfoRow(label: "答錯題數", value: "\(result.questionCount - result.correctCount) 題")
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
                        .foregroundStyle(Color.quizColor)
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
                        .foregroundStyle(.white)
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
