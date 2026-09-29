import JsongCore
import JsongPresentation
import SwiftUI

struct LearnHomeView: View {
    @Environment(ProgressStore.self) private var store

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ScreenHeader(title: "開始學習日文", subtitle: "選擇一個類別開始你的學習之旅")

                    // Japanese characters
                    VStack(alignment: .leading, spacing: 12) {
                        Text("日文字母")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(KanaType.allCases, id: \.self) { type in
                            let kana = KanaData.characters(of: type)
                            NavigationLink {
                                KanaGridView(kanaType: type)
                            } label: {
                                ModuleCard(
                                    title: type.title,
                                    subtitle: "\(type == .hiragana ? "基礎日文字母" : "外來語字母") — \(kana.count) 個字",
                                    sfSymbol: type.symbol,
                                    color: type.color,
                                    progress: DisplayText.fraction(store.progress.learnedCount(of: kana), of: kana.count)
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }

                        ForEach(KanaType.allCases, id: \.self) { type in
                            NavigationLink {
                                FlashCardView(kanaType: type)
                            } label: {
                                ModuleCard(
                                    title: "\(type.title)閃卡",
                                    subtitle: "翻牌練習\(type.title)",
                                    sfSymbol: "rectangle.on.rectangle.angled",
                                    color: type.color
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }

                    // Vocabulary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("詞彙")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(VocabularyCategory.allCases) { category in
                            let words = VocabularyData.words(for: category)
                            NavigationLink {
                                VocabularyListView(category: category)
                            } label: {
                                ModuleCard(
                                    title: category.title,
                                    subtitle: "\(words.count) 個單字",
                                    sfSymbol: category.symbol,
                                    color: .vocabColor,
                                    progress: DisplayText.fraction(store.progress.learnedCount(of: words), of: words.count)
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
