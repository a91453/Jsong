import SwiftUI

struct LearnHomeView: View {
    @EnvironmentObject var progressManager: ProgressManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("開始學習日文")
                            .font(.title2.bold())
                        Text("選擇一個類別開始你的學習之旅")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Japanese Characters Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("日文字母")
                            .font(.headline)
                            .padding(.horizontal)

                        NavigationLink {
                            KanaGridView(kanaType: .hiragana)
                        } label: {
                            ModuleCard(
                                title: "平假名",
                                subtitle: "基礎日文字母 — \(HiraganaData.all.count) 個字",
                                sfSymbol: "character.ja",
                                color: .hiraganaColor,
                                progress: progressManager.hiraganaProgress
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)

                        NavigationLink {
                            KanaGridView(kanaType: .katakana)
                        } label: {
                            ModuleCard(
                                title: "片假名",
                                subtitle: "外來語字母 — \(KatakanaData.all.count) 個字",
                                sfSymbol: "textformat.alt",
                                color: .katakanaColor,
                                progress: progressManager.katakanaProgress
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)

                        NavigationLink {
                            FlashCardView(kanaType: .hiragana)
                        } label: {
                            ModuleCard(
                                title: "平假名閃卡",
                                subtitle: "翻牌練習平假名",
                                sfSymbol: "rectangle.on.rectangle.angled",
                                color: .hiraganaColor
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)

                        NavigationLink {
                            FlashCardView(kanaType: .katakana)
                        } label: {
                            ModuleCard(
                                title: "片假名閃卡",
                                subtitle: "翻牌練習片假名",
                                sfSymbol: "rectangle.on.rectangle.angled",
                                color: .katakanaColor
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }

                    // Vocabulary Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("詞彙")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(VocabularyCategory.allCases) { category in
                            NavigationLink {
                                VocabularyListView(category: category)
                            } label: {
                                let count = VocabularyData.words(for: category).count
                                let learned = VocabularyData.words(for: category)
                                    .filter { progressManager.isVocabLearned($0.id) }.count
                                let prog = count > 0 ? Double(learned) / Double(count) : 0
                                ModuleCard(
                                    title: category.rawValue,
                                    subtitle: "\(count) 個單字",
                                    sfSymbol: category.sfSymbol,
                                    color: .vocabColor,
                                    progress: prog
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("學習")
        }
    }
}
