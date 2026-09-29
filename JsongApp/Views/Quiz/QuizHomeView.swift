import JsongCore
import JsongPresentation
import SwiftUI

struct QuizHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ScreenHeader(title: "測驗你的實力", subtitle: "每次測驗有 10 題隨機題目")

                    ForEach(QuizType.allCases) { type in
                        NavigationLink {
                            MultipleChoiceView(quizType: type)
                        } label: {
                            ModuleCard(
                                title: type.title,
                                subtitle: type.subtitle,
                                sfSymbol: type.symbol,
                                color: .quizColor
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("測驗")
        }
    }
}
