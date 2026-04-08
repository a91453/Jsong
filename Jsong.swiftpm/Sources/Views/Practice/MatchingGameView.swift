import SwiftUI

struct MatchingGameView: View {
    @StateObject private var speaker = SpeechSynthesizer()
    @State private var pairs: [KanaCharacter] = []
    @State private var leftItems: [MatchItem] = []
    @State private var rightItems: [MatchItem] = []
    @State private var selectedLeft: UUID? = nil
    @State private var selectedRight: UUID? = nil
    @State private var matchedIDs: Set<UUID> = []
    @State private var attempts: Int = 0
    @State private var wrongShake: UUID? = nil

    struct MatchItem: Identifiable, Equatable {
        let id = UUID()
        let text: String
        let kanaID: String
    }

    var isComplete: Bool {
        !leftItems.isEmpty && matchedIDs.count == leftItems.count + rightItems.count
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("配對遊戲")
                        .font(.headline)
                    Text("點擊兩邊的項目進行配對")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("嘗試: \(attempts)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(matchedIDs.count / 2) / \(pairs.count)")
                        .font(.headline)
                        .foregroundColor(.quizColor)
                }
            }
            .padding(.horizontal)

            if isComplete {
                // Win state
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.jsongGold)
                    Text("太棒了!")
                        .font(.title.bold())
                    Text("用了 \(attempts) 次嘗試完成")
                        .foregroundColor(.secondary)
                    Button {
                        startNewGame()
                    } label: {
                        Label("再玩一次", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.quizColor))
                    }
                }
                Spacer()
            } else {
                HStack(spacing: 16) {
                    // Left column (kana)
                    VStack(spacing: 10) {
                        ForEach(leftItems) { item in
                            MatchButton(
                                text: item.text,
                                isSelected: selectedLeft == item.id,
                                isMatched: matchedIDs.contains(item.id),
                                isShaking: wrongShake == item.id,
                                fontSize: 32
                            ) {
                                handleLeftTap(item)
                            }
                        }
                    }

                    // Right column (romaji)
                    VStack(spacing: 10) {
                        ForEach(rightItems) { item in
                            MatchButton(
                                text: item.text,
                                isSelected: selectedRight == item.id,
                                isMatched: matchedIDs.contains(item.id),
                                isShaking: wrongShake == item.id,
                                fontSize: 20
                            ) {
                                handleRightTap(item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            if !isComplete {
                Button {
                    startNewGame()
                } label: {
                    Label("重新開始", systemImage: "arrow.clockwise")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("配對遊戲")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if pairs.isEmpty {
                startNewGame()
            }
        }
    }

    private func handleLeftTap(_ item: MatchItem) {
        guard !matchedIDs.contains(item.id) else { return }
        selectedLeft = item.id
        checkMatch()
    }

    private func handleRightTap(_ item: MatchItem) {
        guard !matchedIDs.contains(item.id) else { return }
        selectedRight = item.id
        checkMatch()
    }

    private func checkMatch() {
        guard let left = selectedLeft, let right = selectedRight,
              let leftItem = leftItems.first(where: { $0.id == left }),
              let rightItem = rightItems.first(where: { $0.id == right }) else { return }

        attempts += 1

        if leftItem.kanaID == rightItem.kanaID {
            // Match!
            withAnimation(.spring()) {
                matchedIDs.insert(left)
                matchedIDs.insert(right)
            }
            selectedLeft = nil
            selectedRight = nil
            if let kana = pairs.first(where: { $0.id == leftItem.kanaID }) {
                speaker.speak(kana.character)
            }
        } else {
            // Wrong
            wrongShake = left
            withAnimation(.default.repeatCount(2, autoreverses: true)) {
                wrongShake = right
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                selectedLeft = nil
                selectedRight = nil
                wrongShake = nil
            }
        }
    }

    private func startNewGame() {
        let all = HiraganaData.all.filter { $0.group.isBasic }.shuffled()
        pairs = Array(all.prefix(6))
        leftItems = pairs.map { MatchItem(text: $0.character, kanaID: $0.id) }.shuffled()
        rightItems = pairs.map { MatchItem(text: $0.romaji, kanaID: $0.id) }.shuffled()
        selectedLeft = nil
        selectedRight = nil
        matchedIDs = []
        attempts = 0
    }
}

struct MatchButton: View {
    let text: String
    let isSelected: Bool
    let isMatched: Bool
    let isShaking: Bool
    let fontSize: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(isMatched ? .white : .primary)
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
        .offset(x: isShaking ? 8 : 0)
    }

    var backgroundColor: Color {
        if isMatched { return .jsongMint }
        if isSelected { return .quizColor.opacity(0.2) }
        return Color(.systemBackground)
    }

    var borderColor: Color {
        if isMatched { return .jsongMint }
        if isSelected { return .quizColor }
        return Color(.systemGray4)
    }
}
