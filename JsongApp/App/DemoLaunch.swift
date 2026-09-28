#if DEBUG
import Foundation
import JsongCore
import JsongPresentation

/// Debug-only launch arguments for Simulator screenshots
/// (`.github/workflows/visual-smoke.yml`). Release builds do not contain
/// them; `release-archive.yml` checks that.
///
/// - `-demo-tab <learn|practice|quiz|progress>` opens that tab.
/// - `-demo-progress` starts from sample progress kept in memory only, so
///   the progress screens have something to show. Nothing is saved.
enum DemoLaunch {
    static let tabArgument = "-demo-tab"
    static let progressArgument = "-demo-progress"

    private static var arguments: [String] { ProcessInfo.processInfo.arguments }

    static var initialTab: AppTab? {
        guard let index = arguments.firstIndex(of: tabArgument), arguments.indices.contains(index + 1) else {
            return nil
        }
        return AppTab(rawValue: arguments[index + 1])
    }

    @MainActor
    static func makeProgressStore() -> ProgressStore? {
        guard arguments.contains(progressArgument) else { return nil }
        let store = ProgressStore(storage: InMemoryProgressStorage())
        for kana in HiraganaData.all.prefix(38) {
            store.setKana(kana.id, learned: true)
        }
        for kana in KatakanaData.all.prefix(12) {
            store.setKana(kana.id, learned: true)
        }
        for word in VocabularyData.all where word.category == .greetings || word.category == .food {
            store.setVocabulary(word.id, learned: true)
        }
        let now = Date()
        let samples: [(QuizType, Int)] = [(.kanaToRomaji, 9), (.romajiToKana, 7), (.vocabMeaning, 5)]
        for (offset, sample) in samples.enumerated() {
            store.recordQuiz(QuizResult(
                date: now.addingTimeInterval(Double(offset - samples.count) * 3_600),
                type: sample.0,
                questionCount: 10,
                correctCount: sample.1
            ))
        }
        return store
    }
}
#endif
