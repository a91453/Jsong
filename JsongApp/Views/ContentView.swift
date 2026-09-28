import SwiftUI

/// The app's tabs. Raw values are the `-demo-tab` launch argument values.
enum AppTab: String, CaseIterable {
    case learn
    case practice
    case quiz
    case progress
}

struct ContentView: View {
    @State private var selectedTab: AppTab

    init(initialTab: AppTab = .learn) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            LearnHomeView()
                .tabItem { Label("學習", systemImage: "book.fill") }
                .tag(AppTab.learn)

            PracticeHomeView()
                .tabItem { Label("練習", systemImage: "waveform") }
                .tag(AppTab.practice)

            QuizHomeView()
                .tabItem { Label("測驗", systemImage: "checkmark.circle.fill") }
                .tag(AppTab.quiz)

            ProgressDashboardView()
                .tabItem { Label("進度", systemImage: "chart.bar.fill") }
                .tag(AppTab.progress)
        }
        .tint(.jsongRed)
    }
}
