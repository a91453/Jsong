import SwiftUI

struct KanaCard: View {
    let kana: KanaCharacter
    var isLearned: Bool = false
    var showRomaji: Bool = true

    var body: some View {
        VStack(spacing: 4) {
            Text(kana.character)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.primary)

            if showRomaji {
                Text(kana.romaji)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 60, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isLearned ? Color.jsongMint.opacity(0.3) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isLearned ? Color.jsongMint : Color.clear, lineWidth: 2)
        )
    }
}

struct FlipCardContent: View {
    let frontText: String
    let backTopText: String
    let backBottomText: String
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            // Front
            VStack(spacing: 12) {
                Text(frontText)
                    .font(.system(size: 80, weight: .medium))
                Text("點擊翻牌")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.jsongSakura, lineWidth: 2)
            )
            .opacity(isFlipped ? 0 : 1)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Back
            VStack(spacing: 16) {
                Text(backTopText)
                    .font(.system(size: 48, weight: .medium))
                Text(backBottomText)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.jsongSakura.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.jsongSakura, lineWidth: 2)
            )
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                isFlipped.toggle()
            }
        }
    }
}
