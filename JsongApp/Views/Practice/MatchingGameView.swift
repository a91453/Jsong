import JsongCore
import SwiftUI

struct MatchingGameView: View {
    @State private var game = MatchingGame.randomBasicHiragana()
    /// Cards of the last wrong pick, briefly shown in red.
    @State private var mismatchedCards: Set<Int> = []

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("配對遊戲")
                        .font(.headline)
                    Text("點擊兩邊的項目進行配對")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("嘗試: \(game.attempts)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(game.matchedCount) / \(game.pairCount)")
                        .font(.headline)
                        .foregroundStyle(Color.quizColor)
                }
            }
            .padding(.horizontal)

            if game.isComplete {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.jsongGold)
                    Text("太棒了！")
                        .font(.title.bold())
                    Text("用了 \(game.attempts) 次嘗試完成")
                        .foregroundStyle(.secondary)
                    Button {
                        startNewGame()
                    } label: {
                        Label("再玩一次", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.quizColor))
                    }
                }
                Spacer()
            } else {
                HStack(spacing: 16) {
                    column(game.left, side: .left, fontSize: 32)
                    column(game.right, side: .right, fontSize: 20)
                }
                .padding(.horizontal)
            }

            Spacer()

            if !game.isComplete {
                Button {
                    startNewGame()
                } label: {
                    Label("重新開始", systemImage: "arrow.clockwise")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("配對遊戲")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func column(_ cards: [MatchingGame.Card], side: MatchingGame.Side, fontSize: CGFloat) -> some View {
        VStack(spacing: 10) {
            ForEach(cards) { card in
                MatchButton(
                    text: card.text,
                    isSelected: (side == .left ? game.selectedLeft : game.selectedRight) == card.id,
                    isMatched: game.isMatched(card),
                    isWrong: mismatchedCards.contains(card.id),
                    fontSize: fontSize
                ) {
                    select(card, on: side)
                }
            }
        }
    }

    private func select(_ card: MatchingGame.Card, on side: MatchingGame.Side) {
        switch game.select(card.id, on: side) {
        case .matched(let pairID)?:
            if let kana = KanaData.all.first(where: { $0.id == pairID }) {
                SpeechSynthesizer.shared.speak(kana.character)
            }
        case .mismatched(let left, let right)?:
            withAnimation(.default.repeatCount(2, autoreverses: true)) {
                mismatchedCards = [left, right]
            }
            Task {
                try? await Task.sleep(for: .milliseconds(600))
                mismatchedCards = []
            }
        case .selected?, nil:
            break
        }
    }

    private func startNewGame() {
        game = .randomBasicHiragana()
        mismatchedCards = []
    }
}

struct MatchButton: View {
    let text: String
    let isSelected: Bool
    let isMatched: Bool
    let isWrong: Bool
    let fontSize: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundStyle(isMatched ? Color.white : Color.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 2)
                )
        }
        .disabled(isMatched)
        .offset(x: isWrong ? 8 : 0)
    }

    private var backgroundColor: Color {
        if isMatched { return .jsongMint }
        if isWrong { return .jsongRed.opacity(0.15) }
        if isSelected { return .quizColor.opacity(0.2) }
        return Color(.systemBackground)
    }

    private var borderColor: Color {
        if isMatched { return .jsongMint }
        if isWrong { return .jsongRed }
        if isSelected { return .quizColor }
        return Color(.systemGray4)
    }
}
