import SwiftUI

struct VocabularyListView: View {
    let category: VocabularyCategory
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speaker = SpeechSynthesizer()
    @State private var selectedWord: VocabularyWord?

    var words: [VocabularyWord] {
        VocabularyData.words(for: category)
    }

    var body: some View {
        List {
            ForEach(words) { word in
                Button {
                    selectedWord = word
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.japanese)
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                            Text(word.reading)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text(word.meaning)
                            .font(.subheadline)
                            .foregroundColor(.vocabColor)

                        if progressManager.isVocabLearned(word.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.jsongMint)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle(category.rawValue)
        .sheet(item: $selectedWord) { word in
            VocabularyDetailView(word: word)
        }
    }
}

struct VocabularyDetailView: View {
    let word: VocabularyWord
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speaker = SpeechSynthesizer()
    @Environment(\.dismiss) private var dismiss
    @State private var showExample = false

    var isLearned: Bool {
        progressManager.isVocabLearned(word.id)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Main word
                    VStack(spacing: 8) {
                        Text(word.japanese)
                            .font(.system(size: 64, weight: .bold))
                        Text(word.reading)
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text(word.romaji)
                            .font(.headline)
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.top, 20)

                    // Speak button
                    Button {
                        speaker.speak(word.japanese)
                    } label: {
                        Label("播放發音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.jsongRed))
                    }

                    // Meaning
                    VStack(spacing: 8) {
                        Text("意思")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(word.meaning)
                            .font(.title2.bold())
                            .foregroundColor(.vocabColor)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.vocabColor.opacity(0.1))
                    )
                    .padding(.horizontal)

                    // Example sentence
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
                            .foregroundColor(.primary)
                        }

                        if showExample {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(word.exampleSentence)
                                    .font(.body)
                                Divider()
                                Text(word.sentenceMeaning)
                                    .font(.body)
                                    .foregroundColor(.secondary)

                                Button {
                                    speaker.speak(word.exampleSentence)
                                } label: {
                                    Label("播放例句", systemImage: "speaker.wave.1.fill")
                                        .font(.subheadline)
                                        .foregroundColor(.jsongRed)
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

                    // Mark as learned
                    Button {
                        progressManager.toggleVocabLearned(word.id)
                    } label: {
                        Label(
                            isLearned ? "已學會 ✓" : "標記為已學會",
                            systemImage: isLearned ? "checkmark.circle.fill" : "circle"
                        )
                        .font(.headline)
                        .foregroundColor(.white)
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
