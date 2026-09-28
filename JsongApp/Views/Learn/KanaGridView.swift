import JsongCore
import JsongPresentation
import SwiftUI

struct KanaGridView: View {
    let kanaType: KanaType
    @Environment(ProgressStore.self) private var store
    @State private var selectedKana: KanaCharacter?
    /// Nil shows every row.
    @State private var filter: KanaGroup.Kind?

    private var allCharacters: [KanaCharacter] {
        KanaData.characters(of: kanaType)
    }

    private var visibleGroups: [KanaGroup] {
        KanaGroup.allCases.filter { group in
            (filter == nil || group.kind == filter) && allCharacters.contains { $0.group == group }
        }
    }

    private func characters(in group: KanaGroup) -> [KanaCharacter] {
        allCharacters.filter { $0.group == group }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("篩選", selection: $filter) {
                    Text("全部").tag(KanaGroup.Kind?.none)
                    ForEach(KanaGroup.Kind.allCases, id: \.self) { kind in
                        Text(kind.title).tag(KanaGroup.Kind?.some(kind))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                HStack {
                    Text("已學會: \(store.progress.learnedCount(of: allCharacters))/\(allCharacters.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)

                ForEach(visibleGroups) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.title)
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                            ForEach(characters(in: group)) { kana in
                                Button {
                                    selectedKana = kana
                                } label: {
                                    KanaCard(kana: kana, isLearned: store.progress.isKanaLearned(kana.id))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(kanaType.title)
        .sheet(item: $selectedKana) { kana in
            KanaDetailView(kana: kana)
        }
    }
}
