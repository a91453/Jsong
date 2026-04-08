import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header stats
                    HStack(spacing: 12) {
                        StatTile(
                            title: "連續天數",
                            value: "\(progressManager.progress.dailyStreak)",
                            unit: "天",
                            color: .jsongRed,
                            icon: "flame.fill"
                        )

                        StatTile(
                            title: "學習次數",
                            value: "\(progressManager.progress.totalStudySessions)",
                            unit: "次",
                            color: .jsongGold,
                            icon: "graduationcap.fill"
                        )
                    }
                    .padding(.horizontal)

                    // Character progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("字母進度")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 12) {
                            KanaProgressCard(
                                title: "平假名",
                                learned: progressManager.progress.learnedKanaIDs.filter { $0.hasPrefix("hira_") }.count,
                                total: HiraganaData.all.count,
                                color: .hiraganaColor,
                                progress: progressManager.hiraganaProgress
                            )

                            KanaProgressCard(
                                title: "片假名",
                                learned: progressManager.progress.learnedKanaIDs.filter { $0.hasPrefix("kata_") }.count,
                                total: KatakanaData.all.count,
                                color: .katakanaColor,
                                progress: progressManager.katakanaProgress
                            )
                        }
                        .padding(.horizontal)
                    }

                    // Vocabulary progress
                    VStack(alignment: .leading, spacing: 12) {
                        Text("詞彙進度")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.vocabColor)
                                Text("已學會 \(progressManager.progress.learnedVocabIDs.count) / \(VocabularyData.all.count) 個單字")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(Int(progressManager.vocabProgress * 100))%")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.vocabColor)
                            }
                            ProgressView(value: progressManager.vocabProgress)
                                .tint(.vocabColor)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal)

                        // Per category
                        VStack(spacing: 8) {
                            ForEach(VocabularyCategory.allCases) { category in
                                let total = VocabularyData.words(for: category).count
                                let learned = VocabularyData.words(for: category)
                                    .filter { progressManager.isVocabLearned($0.id) }.count
                                CategoryProgressRow(
                                    category: category,
                                    learned: learned,
                                    total: total
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

                    // Quiz history
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("測驗紀錄")
                                .font(.headline)
                            Spacer()
                            if !progressManager.progress.quizHistory.isEmpty {
                                Text("平均: \(Int(progressManager.averageQuizScore))%")
                                    .font(.subheadline)
                                    .foregroundColor(.quizColor)
                            }
                        }
                        .padding(.horizontal)

                        if progressManager.recentQuizzes.isEmpty {
                            Text("還沒有測驗紀錄")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                )
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(progressManager.recentQuizzes) { quiz in
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
                .foregroundColor(color)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
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
    let progress: Double

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(color)

            ProgressRing(progress: progress, lineWidth: 8, size: 80, color: color)

            Text("\(learned) / \(total)")
                .font(.caption)
                .foregroundColor(.secondary)
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

    var progress: Double {
        total > 0 ? Double(learned) / Double(total) : 0
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.sfSymbol)
                .foregroundColor(.vocabColor)
                .frame(width: 24)

            Text(category.rawValue)
                .font(.subheadline)

            Spacer()

            Text("\(learned)/\(total)")
                .font(.caption)
                .foregroundColor(.secondary)
                .monospacedDigit()

            ProgressView(value: progress)
                .tint(.vocabColor)
                .frame(width: 80)
        }
    }
}

struct QuizHistoryRow: View {
    let quiz: QuizResult

    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM/dd HH:mm"
        return f
    }()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: quiz.quizType.sfSymbol)
                .foregroundColor(.quizColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(quiz.quizType.rawValue)
                    .font(.subheadline)
                Text(Self.dateFormatter.string(from: quiz.date))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(quiz.correctAnswers)/\(quiz.totalQuestions)")
                    .font(.subheadline.bold())
                    .foregroundColor(.quizColor)
                Text(quiz.grade)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
