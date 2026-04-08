import SwiftUI

struct KanaGridView: View {
    let kanaType: KanaType
    @EnvironmentObject var progressManager: ProgressManager
    @State private var selectedKana: KanaCharacter?
    @State private var filterMode: FilterMode = .all

    enum FilterMode: String, CaseIterable {
        case all = "全部"
        case basic = "基本"
        case dakuten = "濁音"
        case combo = "拗音"
    }

    var allCharacters: [KanaCharacter] {
        kanaType == .hiragana ? HiraganaData.all : KatakanaData.all
    }

    var filteredGroups: [KanaGroup] {
        let groups = Array(Set(allCharacters.map { $0.group }))
        return KanaGroup.allCases.filter { group in
            groups.contains(group) && matchesFilter(group)
        }
    }

    func matchesFilter(_ group: KanaGroup) -> Bool {
        switch filterMode {
        case .all: return true
        case .basic: return group.isBasic
        case .dakuten: return group.isDakuten
        case .combo: return group.isCombo
        }
    }

    func characters(for group: KanaGroup) -> [KanaCharacter] {
        allCharacters.filter { $0.group == group }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Filter
                Picker("篩選", selection: $filterMode) {
                    ForEach(FilterMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Stats
                let total = allCharacters.count
                let learned = allCharacters.filter { progressManager.isKanaLearned($0.id) }.count
                HStack {
                    Text("已學會: \(learned)/\(total)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)

                // Grid by groups
                ForEach(filteredGroups) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.displayName)
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                            ForEach(characters(for: group)) { kana in
                                Button {
                                    selectedKana = kana
                                } label: {
                                    KanaCard(
                                        kana: kana,
                                        isLearned: progressManager.isKanaLearned(kana.id)
                                    )
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
        .navigationTitle(kanaType == .hiragana ? "平假名" : "片假名")
        .sheet(item: $selectedKana) { kana in
            KanaDetailView(kana: kana)
        }
    }
}
