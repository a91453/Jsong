import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LearnHomeView()
                .tabItem {
                    Label("學習", systemImage: "book.fill")
                }
                .tag(0)

            PracticeHomeView()
                .tabItem {
                    Label("練習", systemImage: "waveform")
                }
                .tag(1)

            QuizHomeView()
                .tabItem {
                    Label("測驗", systemImage: "checkmark.circle.fill")
                }
                .tag(2)

            ProgressDashboardView()
                .tabItem {
                    Label("進度", systemImage: "chart.bar.fill")
                }
                .tag(3)
        }
        .tint(Color.jsongRed)
    }
}
