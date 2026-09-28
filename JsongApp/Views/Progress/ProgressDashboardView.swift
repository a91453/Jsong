import JsongCore
import JsongPresentation
import SwiftUI

struct ProgressDashboardView: View {
    @Environment(ProgressStore.self) private var store

    var body: some View {
        let progress = store.progress
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        StatTile(
                            title: "連續天數",
                            value: "\(store.currentStreak)",
                            unit: "天",
                            color: .jsongRed,
                            icon: "flame.fill"
                        )

                        StatTile(
                            title: "測驗次數",
                            value: "\(progress.quizHistory.count)",
                            unit: "次",
                            color: .jsongGold,
                            icon: "graduationcap.fill"
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("字母進度")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            ForEach(KanaType.allCases, id: \.self) { type in
                                let kana = KanaData.characters(of: type)
                                KanaProgressCard(
                                    title: type.title,
                                    learned: progress.learnedCount(of: kana),
                                    total: kana.count,
                                    color: type.color
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("詞彙進度")
                            .font(.headline)
                            .padding(.horizontal)

                        let learnedWords = progress.learnedCount(of: VocabularyData.all)
                        let wordFraction = DisplayText.fraction(learnedWords, of: VocabularyData.all.count)
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(Color.vocabColor)
                                Text("已學會 \(learnedWords) / \(VocabularyData.all.count) 個單字")
                                    .font(.subheadline)
                                Spacer()
                                Text(DisplayText.percent(wordFraction))
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color.vocabColor)
                            }
                            ProgressView(value: wordFraction)
                                .tint(.vocabColor)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal)

                        VStack(spacing: 8) {
                            ForEach(VocabularyCategory.allCases) { category in
                                let words = VocabularyData.words(for: category)
                                CategoryProgressRow(
                                    category: category,
                                    learned: progress.learnedCount(of: words),
                                    total: words.count
                                )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("測驗紀錄")
                                .font(.headline)
                            Spacer()
                            if let average = progress.averageQuizPercentage {
                                Text("平均: \(DisplayText.percent(average / 100))")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.quizColor)
                            }
                        }
                        .padding(.horizontal)

                        let recent = progress.recentQuizzes(limit: 10)
                        if recent.isEmpty {
                            Text("還沒有測驗紀錄")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                )
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(Array(recent.enumerated()), id: \.offset) { _, quiz in
                                    QuizHistoryRow(quiz: quiz)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("進度")
        }
    }
}

struct StatTile: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
    }
}

struct KanaProgressCard: View {
    let title: String
    let learned: Int
    let total: Int
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(color)

            ProgressRing(progress: DisplayText.fraction(learned, of: total), lineWidth: 8, size: 80, color: color)

            Text("\(learned) / \(total)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
    }
}

struct CategoryProgressRow: View {
    let category: VocabularyCategory
    let learned: Int
    let total: Int

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.symbol)
                .foregroundStyle(Color.vocabColor)
                .frame(width: 24)

            Text(category.title)
                .font(.subheadline)

            Spacer()

            Text("\(learned)/\(total)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()

            ProgressView(value: DisplayText.fraction(learned, of: total))
                .tint(.vocabColor)
                .frame(width: 80)
        }
    }
}

struct QuizHistoryRow: View {
    let quiz: QuizResult

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: quiz.type.symbol)
                .foregroundStyle(Color.quizColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(quiz.type.title)
                    .font(.subheadline)
                Text(quiz.date, format: .dateTime.month(.twoDigits).day(.twoDigits).hour().minute())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(quiz.correctCount)/\(quiz.questionCount)")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.quizColor)
                Text(quiz.grade.title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
