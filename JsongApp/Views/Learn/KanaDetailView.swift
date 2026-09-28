import JsongCore
import JsongPresentation
import SwiftUI

struct KanaDetailView: View {
    let kana: KanaCharacter
    @Environment(ProgressStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    private var isLearned: Bool {
        store.progress.isKanaLearned(kana.id)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(kana.character)
                            .font(.system(size: 120, weight: .medium))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)

                        Text(kana.romaji)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    Button {
                        SpeechSynthesizer.shared.speak(kana.character)
                    } label: {
                        Label("播放發音", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.jsongRed))
                    }

                    VStack(spacing: 12) {
                        InfoRow(label: "類型", value: kana.type.title)
                        InfoRow(label: "分組", value: kana.group.title)
                        InfoRow(label: "筆畫數", value: "\(kana.strokeCount) 畫")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Label("記憶提示", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(Color.jsongGold)

                        Text(kana.mnemonicHint)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.jsongGold.opacity(0.1))
                    )
                    .padding(.horizontal)

                    Button {
                        store.toggleKana(kana.id)
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
