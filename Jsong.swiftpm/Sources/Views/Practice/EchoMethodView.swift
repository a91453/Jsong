import SwiftUI

struct EchoMethodView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speaker = SpeechSynthesizer()

    @State private var sessionWords: [VocabularyWord] = []
    @State private var currentIndex = 0
    @State private var phase: EchoPhase = .see

    enum EchoPhase: Int, CaseIterable {
        case see = 0       // 只看漢字
        case read = 1      // 顯示讀音
        case understand = 2 // 顯示中文意思
        case example = 3   // 顯示例句
        case recall = 4    // 自我檢測

        var title: String {
            switch self {
            case .see: return "看字"
            case .read: return "讀音"
            case .understand: return "理解"
            case .example: return "例句"
            case .recall: return "複習"
            }
        }

        var instruction: String {
            switch self {
            case .see: return "仔細觀察這個詞 — 點擊繼續"
            case .read: return "記住它的讀音 — 點擊繼續"
            case .understand: return "理解它的意思 — 點擊繼續"
            case .example: return "看看如何在句子中使用 — 點擊繼續"
            case .recall: return "記得這個詞了嗎?"
            }
        }
    }

    var currentWord: VocabularyWord? {
        guard currentIndex < sessionWords.count else { return nil }
        return sessionWords[currentIndex]
    }

    var body: some View {
        VStack(spacing: 20) {
            // Progress
            if !sessionWords.isEmpty {
                HStack {
                    Text("\(currentIndex + 1) / \(sessionWords.count)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(phase.title)
                        .font(.headline)
                        .foregroundColor(.practiceColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.practiceColor.opacity(0.15)))
                }
                .padding(.horizontal)

                ProgressView(value: Double(phase.rawValue + 1), total: Double(EchoPhase.allCases.count))
                    .tint(.practiceColor)
                    .padding(.horizontal)
            }

            Spacer()

            if let word = currentWord {
                VStack(spacing: 24) {
                    // Main display
                    VStack(spacing: 16) {
                        Text(word.japanese)
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.primary)

                        if phase.rawValue >= EchoPhase.read.rawValue {
                            Text(word.reading)
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .transition(.opacity.combined(with: .move(edge: .top)))

                            Text(word.romaji)
                                .font(.headline)
                                .foregroundColor(.secondary.opacity(0.7))
                                .transition(.opacity)
                        }

                        if phase.rawValue >= EchoPhase.understand.rawValue {
                            Divider().padding(.horizontal, 40)

                            Text(word.meaning)
                                .font(.title3.bold())
                                .foregroundColor(.practiceColor)
                                .transition(.opacity.combined(with: .scale))
                        }

                        if phase == .example {
                            VStack(spacing: 8) {
                                Text(word.exampleSentence)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                Text(word.sentenceMeaning)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
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

                    // Speak button
                    Button {
                        speaker.speak(phase == .example ? word.exampleSentence : word.japanese)
                    } label: {
                        Label("播放發音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.practiceColor))
                    }

                    // Instruction
                    Text(phase.instruction)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                // Session complete
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.practiceColor)
                    Text("練習完成!")
                        .font(.title.bold())
                    Text("你已經完成本次回音練習")
                        .foregroundColor(.secondary)
                    Button {
                        startNewSession()
                    } label: {
                        Label("再來一次", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.practiceColor))
                    }
                }
            }

            Spacer()

            // Bottom action
            if currentWord != nil {
                HStack(spacing: 16) {
                    if phase == .recall {
                        Button {
                            nextWord(rememberd: false)
                        } label: {
                            Label("再練習", systemImage: "arrow.counterclockwise")
                                .font(.headline)
                                .foregroundColor(.jsongRed)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.jsongRed.opacity(0.15))
                                )
                        }

                        Button {
                            nextWord(rememberd: true)
                        } label: {
                            Label("記住了", systemImage: "checkmark")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.jsongMint)
                                )
                        }
                    } else {
                        Button {
                            nextPhase()
                        } label: {
                            Label("繼續", systemImage: "arrow.right")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.practiceColor)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("回音練習法")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if sessionWords.isEmpty {
                startNewSession()
            }
        }
    }

    private func nextPhase() {
        withAnimation(.easeInOut(duration: 0.4)) {
            if let next = EchoPhase(rawValue: phase.rawValue + 1) {
                phase = next
            }
        }
    }

    private func nextWord(rememberd: Bool) {
        if rememberd, let word = currentWord {
            progressManager.markVocabLearned(word.id)
        }
        withAnimation {
            if currentIndex + 1 < sessionWords.count {
                currentIndex += 1
                phase = .see
            } else {
                currentIndex = sessionWords.count
            }
        }
    }

    private func startNewSession() {
        sessionWords = Array(VocabularyData.all.shuffled().prefix(10))
        currentIndex = 0
        phase = .see
    }
}
