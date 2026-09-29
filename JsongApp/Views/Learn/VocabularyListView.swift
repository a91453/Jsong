import JsongCore
import JsongPresentation
import SwiftUI

struct VocabularyListView: View {
    let category: VocabularyCategory
    @Environment(ProgressStore.self) private var store
    @State private var selectedWord: VocabularyWord?

    var body: some View {
        List {
            ForEach(VocabularyData.words(for: category)) { word in
                Button {
                    selectedWord = word
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.japanese)
                                .font(.title3.bold())
                                .foregroundStyle(.primary)
                            Text(word.reading)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(word.meaning)
                            .font(.subheadline)
                            .foregroundStyle(Color.vocabColor)

                        if store.progress.isVocabularyLearned(word.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.jsongMint)
                        }
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle(category.title)
        .sheet(item: $selectedWord) { word in
            VocabularyDetailView(word: word)
        }
    }
}

struct VocabularyDetailView: View {
    let word: VocabularyWord
    @Environment(ProgressStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showExample = false

    private var isLearned: Bool {
        store.progress.isVocabularyLearned(word.id)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(word.japanese)
                            .font(.system(size: 64, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                        Text(word.reading)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text(word.romaji)
                            .font(.headline)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)

                    Button {
                        SpeechSynthesizer.shared.speak(word.japanese)
                    } label: {
                        Label("播放發音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.jsongRed))
                    }

                    VStack(spacing: 8) {
                        Text("意思")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(word.meaning)
                            .font(.title2.bold())
                            .foregroundStyle(Color.vocabColor)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.vocabColor.opacity(0.1))
                    )
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Button {
                            withAnimation {
                                showExample.toggle()
                            }
                        } label: {
                            HStack {
                                Label("例句", systemImage: "text.quote")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: showExample ? "chevron.up" : "chevron.down")
                            }
                            .foregroundStyle(.primary)
                        }

                        if showExample {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(word.exampleSentence)
                                    .font(.body)
                                Divider()
                                Text(word.sentenceMeaning)
                                    .font(.body)
                                    .foregroundStyle(.secondary)

                                Button {
                                    SpeechSynthesizer.shared.speak(word.exampleSentence)
                                } label: {
                                    Label("播放例句", systemImage: "speaker.wave.1.fill")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.jsongRed)
                                }
                                .padding(.top, 4)
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)

                    Button {
                        store.toggleVocabulary(word.id)
                    } label: {
                        Label(
                            isLearned ? "已學會 ✓" : "標記為已學會",
                            systemImage: isLearned ? "checkmark.circle.fill" : "circle"
                        )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isLearned ? Color.jsongMint : Color.jsongRed)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(word.japanese)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
