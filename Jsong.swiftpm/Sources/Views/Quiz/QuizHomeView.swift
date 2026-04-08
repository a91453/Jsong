import SwiftUI

struct QuizHomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("測驗你的實力")
                            .font(.title2.bold())
                        Text("每次測驗有 10 題隨機題目")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    ForEach(QuizType.allCases) { type in
                        NavigationLink {
                            MultipleChoiceView(quizType: type)
                        } label: {
                            ModuleCard(
                                title: type.rawValue,
                                subtitle: type.description,
                                sfSymbol: type.sfSymbol,
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
