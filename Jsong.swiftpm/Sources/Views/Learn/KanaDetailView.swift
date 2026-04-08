import SwiftUI

struct KanaDetailView: View {
    let kana: KanaCharacter
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speaker = SpeechSynthesizer()
    @Environment(\.dismiss) private var dismiss

    var isLearned: Bool {
        progressManager.isKanaLearned(kana.id)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Large character display
                    VStack(spacing: 8) {
                        Text(kana.character)
                            .font(.system(size: 120, weight: .medium))
                            .foregroundColor(.primary)

                        Text(kana.romaji)
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Speak button
                    Button {
                        speaker.speak(kana.character)
                    } label: {
                        Label("播放發音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.jsongRed))
                    }

                    // Info cards
                    VStack(spacing: 12) {
                        InfoRow(label: "類型", value: kana.type.rawValue)
                        InfoRow(label: "分組", value: kana.group.displayName)
                        InfoRow(label: "筆畫數", value: "\(kana.strokeCount) 畫")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)

                    // Mnemonic hint
                    VStack(alignment: .leading, spacing: 8) {
                        Label("記憶提示", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundColor(.jsongGold)

                        Text(kana.mnemonicHint)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.jsongGold.opacity(0.1))
                    )
                    .padding(.horizontal)

                    // Mark as learned
                    Button {
                        progressManager.toggleKanaLearned(kana.id)
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
            .navigationTitle(kana.character)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
