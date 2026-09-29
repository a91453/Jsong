import JsongCore
import JsongPresentation
import SwiftUI

struct EchoMethodView: View {
    @Environment(ProgressStore.self) private var store
    @State private var session = EchoSession.random()

    var body: some View {
        VStack(spacing: 20) {
            if !session.isFinished {
                HStack {
                    Text("\(session.currentIndex + 1) / \(session.words.count)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(session.phase.title)
                        .font(.headline)
                        .foregroundStyle(Color.practiceColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.practiceColor.opacity(0.15)))
                }
                .padding(.horizontal)

                ProgressView(value: Double(session.phase.rawValue + 1), total: Double(EchoPhase.allCases.count))
                    .tint(.practiceColor)
                    .padding(.horizontal)
            }

            Spacer()

            if let word = session.currentWord {
                wordCard(word)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.practiceColor)
                    Text("練習完成！")
                        .font(.title.bold())
                    Text("你已經完成本次回音練習")
                        .foregroundStyle(.secondary)
                    Button {
                        session = .random()
                    } label: {
                        Label("再來一次", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.practiceColor))
                    }
                }
            }

            Spacer()

            if session.currentWord != nil {
                bottomActions
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("回音練習法")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func wordCard(_ word: VocabularyWord) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text(word.japanese)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)

                if session.phase >= .read {
                    Text(word.reading)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .transition(.opacity.combined(with: .move(edge: .top)))

                    Text(word.romaji)
                        .font(.headline)
                        .foregroundStyle(.tertiary)
                        .transition(.opacity)
                }

                if session.phase >= .understand {
                    Divider().padding(.horizontal, 40)

                    Text(word.meaning)
                        .font(.title3.bold())
                        .foregroundStyle(Color.practiceColor)
                        .transition(.opacity.combined(with: .scale))
                }

                if session.phase == .example {
                    VStack(spacing: 8) {
                        Text(word.exampleSentence)
                            .font(.body)
                            .multilineTextAlignment(.center)
                        Text(word.sentenceMeaning)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.practiceColor.opacity(0.08))
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8)
            )
            .padding(.horizontal)

            Button {
                SpeechSynthesizer.shared.speak(session.phase == .example ? word.exampleSentence : word.japanese)
            } label: {
                Label("播放發音", systemImage: "speaker.wave.2.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.practiceColor))
            }

            Text(session.phase.instruction)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var bottomActions: some View {
        if session.phase == .recall {
            HStack(spacing: 16) {
                Button {
                    finishWord(remembered: false)
                } label: {
                    Label("再練習", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                        .foregroundStyle(Color.jsongRed)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.jsongRed.opacity(0.15))
                        )
                }

                Button {
                    finishWord(remembered: true)
                } label: {
                    Label("記住了", systemImage: "checkmark")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.jsongMint)
                        )
                }
            }
        } else {
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    session.advancePhase()
                }
            } label: {
                Label("繼續", systemImage: "arrow.right")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.practiceColor)
                    )
            }
        }
    }

    private func finishWord(remembered: Bool) {
        withAnimation {
            if let word = session.finishWord(remembered: remembered) {
                store.setVocabulary(word.id, learned: true)
            }
        }
    }
}
