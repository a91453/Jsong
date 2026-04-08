import SwiftUI

struct FlashCardView: View {
    let kanaType: KanaType
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speaker = SpeechSynthesizer()
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var offset: CGSize = .zero

    var cards: [KanaCharacter] {
        (kanaType == .hiragana ? HiraganaData.all : KatakanaData.all).shuffled()
    }

    @State private var shuffledCards: [KanaCharacter] = []

    var currentCard: KanaCharacter? {
        guard currentIndex < shuffledCards.count else { return nil }
        return shuffledCards[currentIndex]
    }

    var body: some View {
        VStack(spacing: 20) {
            // Progress
            HStack {
                Text("\(currentIndex + 1) / \(shuffledCards.count)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("已學會: \(shuffledCards.filter { progressManager.isKanaLearned($0.id) }.count)")
                    .font(.subheadline)
                    .foregroundColor(.jsongMint)
            }
            .padding(.horizontal)

            ProgressView(value: Double(currentIndex), total: Double(max(shuffledCards.count, 1)))
                .tint(.jsongRed)
                .padding(.horizontal)

            Spacer()

            if let card = currentCard {
                // Flash card
                FlipCardContent(
                    frontText: card.character,
                    backTopText: card.character,
                    backBottomText: "\(card.romaji)\n\(card.mnemonicHint)",
                    isFlipped: $isFlipped
                )
                .frame(width: 280, height: 360)
                .offset(offset)
                .rotationEffect(.degrees(Double(offset.width / 20)))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > 120 {
                                if value.translation.width > 0 {
                                    progressManager.markKanaLearned(card.id)
                                }
                                withAnimation(.easeOut(duration: 0.3)) {
                                    offset = CGSize(
                                        width: value.translation.width > 0 ? 500 : -500,
                                        height: 0
                                    )
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    nextCard()
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = .zero
                                }
                            }
                        }
                )

                // Swipe hints
                HStack(spacing: 40) {
                    VStack {
                        Image(systemName: "arrow.left")
                        Text("再練習")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)

                    Button {
                        speaker.speak(card.character)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(.jsongRed)
                            .padding()
                            .background(Circle().fill(Color.jsongRed.opacity(0.1)))
                    }

                    VStack {
                        Image(systemName: "arrow.right")
                        Text("已學會")
                            .font(.caption)
                    }
                    .foregroundColor(.jsongMint)
                }
                .padding(.top, 20)

            } else {
                // Completed
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.jsongGold)
                    Text("太棒了！")
                        .font(.title.bold())
                    Text("你已經完成所有閃卡練習")
                        .foregroundColor(.secondary)
                    Button("重新開始") {
                        resetDeck()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.jsongRed))
                }
            }

            Spacer()
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(kanaType == .hiragana ? "平假名閃卡" : "片假名閃卡")
        .onAppear {
            if shuffledCards.isEmpty {
                shuffledCards = cards
            }
        }
    }

    private func nextCard() {
        offset = .zero
        isFlipped = false
        if currentIndex + 1 < shuffledCards.count {
            currentIndex += 1
        } else {
            currentIndex = shuffledCards.count
        }
    }

    private func resetDeck() {
        shuffledCards = cards
        currentIndex = 0
        isFlipped = false
        offset = .zero
    }
}
