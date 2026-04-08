import SwiftUI

struct PracticeHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("互動式練習")
                            .font(.title2.bold())
                        Text("透過練習加深對日文的理解")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    NavigationLink {
                        EchoMethodView()
                    } label: {
                        ModuleCard(
                            title: "回音練習法",
                            subtitle: "四階段漸進式揭示學習 — 看、聽、懂、記",
                            sfSymbol: "waveform.circle.fill",
                            color: .practiceColor
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)

                    NavigationLink {
                        MatchingGameView()
                    } label: {
                        ModuleCard(
                            title: "配對遊戲",
                            subtitle: "將假名與羅馬字配對",
                            sfSymbol: "square.grid.2x2.fill",
                            color: .quizColor
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)

                    // Info card
                    VStack(alignment: .leading, spacing: 12) {
                        Label("什麼是回音練習法?", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundColor(.jsongGold)

                        Text("回音練習法 (Echo Method) 是一種沉浸式日語學習方式，透過看、聽、理解、記憶四個階段，讓你循序漸進地掌握每個單字。")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.jsongGold.opacity(0.1))
                    )
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("練習")
        }
    }
}
