import JsongCore
import JsongPresentation
import SwiftUI

struct FlashCardView: View {
    let kanaType: KanaType
    @Environment(ProgressStore.self) private var store
    @State private var deck: [KanaCharacter] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var offset: CGSize = .zero
    /// True while a swiped card flies off, so it cannot be swiped twice.
    @State private var isAdvancing = false

    private var currentCard: KanaCharacter? {
        currentIndex < deck.count ? deck[currentIndex] : nil
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(min(currentIndex + 1, deck.count)) / \(deck.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("已學會: \(store.progress.learnedCount(of: deck))")
                    .font(.subheadline)
                    .foregroundStyle(Color.jsongMint)
            }
            .padding(.horizontal)

            ProgressView(value: Double(currentIndex), total: Double(max(deck.count, 1)))
                .tint(.jsongRed)
                .padding(.horizontal)

            Spacer()

            if let card = currentCard {
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
                            guard !isAdvancing else { return }
                            offset = value.translation
                        }
                        .onEnded { value in
                            guard !isAdvancing else { return }
                            swipeEnded(card: card, translation: value.translation.width)
                        }
                )

                HStack(spacing: 40) {
                    VStack {
                        Image(systemName: "arrow.left")
                        Text("再練習")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)

                    Button {
                        SpeechSynthesizer.shared.speak(card.character)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundStyle(Color.jsongRed)
                            .padding()
                            .background(Circle().fill(Color.jsongRed.opacity(0.1)))
                    }
                    .accessibilityLabel("播放發音")

                    VStack {
                        Image(systemName: "arrow.right")
                        Text("已學會")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.jsongMint)
                }
                .padding(.top, 20)
            } else if !deck.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.jsongGold)
                    Text("太棒了！")
                        .font(.title.bold())
                    Text("你已經完成所有閃卡練習")
                        .foregroundStyle(.secondary)
                    Button("重新開始") {
                        resetDeck()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.jsongRed))
                }
            }

            Spacer()
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("\(kanaType.title)閃卡")
        .onAppear {
            if deck.isEmpty {
                resetDeck()
            }
        }
    }

    /// A swipe past 120 points moves on; to the right it also marks the
    /// card learned.
    private func swipeEnded(card: KanaCharacter, translation: CGFloat) {
        guard abs(translation) > 120 else {
            withAnimation(.spring()) {
                offset = .zero
            }
            return
        }
        if translation > 0 {
            store.setKana(card.id, learned: true)
        }
        isAdvancing = true
        withAnimation(.easeOut(duration: 0.3)) {
            offset = CGSize(width: translation > 0 ? 500 : -500, height: 0)
        }
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            offset = .zero
            isFlipped = false
            currentIndex += 1
            isAdvancing = false
        }
    }

    private func resetDeck() {
        deck = KanaData.characters(of: kanaType).shuffled()
        currentIndex = 0
        isFlipped = false
        offset = .zero
        isAdvancing = false
    }
}
