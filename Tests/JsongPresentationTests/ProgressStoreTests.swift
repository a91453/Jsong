import Foundation
import JsongCore
import JsongPresentation
import XCTest

/// Stands in for the calendar: the day a store considers "today".
@MainActor
private final class FakeToday {
    var day = StudyDay(year: 2026, month: 9, day: 1)!
}

@MainActor
private func makeStore(_ storage: InMemoryProgressStorage, today: FakeToday = FakeToday()) -> ProgressStore {
    ProgressStore(storage: storage, today: { today.day })
}

// ProgressStore is main-actor isolated. Test methods hop onto the main actor
// with `MainActor.run` instead of isolating the XCTestCase subclass, which
// XCTest on Linux cannot run.
final class ProgressStoreTests: XCTestCase {
    func testStartsEmptyAndSavesEveryChange() async throws {
        try await MainActor.run {
            let storage = InMemoryProgressStorage()
            let store = makeStore(storage)
            XCTAssertEqual(store.progress, UserProgress())
            XCTAssertNil(storage.data)

            store.setKana("hira_a", learned: true)
            let saved = try XCTUnwrap(storage.data)
            XCTAssertEqual(try ProgressCoding.decode(saved), store.progress)

            store.toggleVocabulary("v_arigatou")
            XCTAssertTrue(store.progress.isVocabularyLearned("v_arigatou"))
            XCTAssertEqual(try ProgressCoding.decode(try XCTUnwrap(storage.data)), store.progress)
        }
    }

    func testReloadsSavedProgress() async {
        await MainActor.run {
            let storage = InMemoryProgressStorage()
            let first = makeStore(storage)
            first.toggleKana("kata_ka")
            first.recordQuiz(QuizResult(date: Date(timeIntervalSince1970: 5), type: .kanaToRomaji, questionCount: 10, correctCount: 9))

            let second = makeStore(storage)
            XCTAssertEqual(second.progress, first.progress)
            XCTAssertTrue(second.progress.isKanaLearned("kata_ka"))
            XCTAssertEqual(second.progress.quizHistory.count, 1)
        }
    }

    func testUnreadableDataIsKeptAndTheStoreStartsEmpty() async {
        await MainActor.run {
            let garbage = Data("not json".utf8)
            let storage = InMemoryProgressStorage(data: garbage)
            let store = makeStore(storage)
            XCTAssertEqual(store.progress, UserProgress())
            XCTAssertEqual(storage.unreadable, garbage)
            XCTAssertEqual(storage.data, garbage, "nothing is overwritten until the next change")
        }
    }

    func testStreakFollowsTheInjectedDay() async {
        await MainActor.run {
            let today = FakeToday()
            let store = makeStore(InMemoryProgressStorage(), today: today)
            store.setKana("hira_a", learned: true)
            today.day = StudyDay(year: 2026, month: 9, day: 2)!
            XCTAssertEqual(store.currentStreak, 1)
            store.toggleKana("hira_i")
            XCTAssertEqual(store.currentStreak, 2)
            today.day = StudyDay(year: 2026, month: 9, day: 4)!
            XCTAssertEqual(store.currentStreak, 0)
        }
    }

    func testTogglesFlipLearnedState() async {
        await MainActor.run {
            let store = makeStore(InMemoryProgressStorage())
            store.toggleKana("hira_a")
            XCTAssertTrue(store.progress.isKanaLearned("hira_a"))
            store.toggleKana("hira_a")
            XCTAssertFalse(store.progress.isKanaLearned("hira_a"))
            store.setVocabulary("v_arigatou", learned: true)
            store.toggleVocabulary("v_arigatou")
            XCTAssertFalse(store.progress.isVocabularyLearned("v_arigatou"))
        }
    }

    func testUserDefaultsStorageRoundTrip() throws {
        let suite = "JsongPresentationTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let storage = UserDefaultsProgressStorage(defaults: defaults)
        XCTAssertNil(storage.load())
        storage.save(Data([1, 2, 3]))
        XCTAssertEqual(storage.load(), Data([1, 2, 3]))
        storage.preserveUnreadable(Data([4]))
        XCTAssertEqual(defaults.data(forKey: UserDefaultsProgressStorage.unreadableKey), Data([4]))
    }
}

final class StudyDayFromDateTests: XCTestCase {
    func testUsesTheGivenTimeZone() throws {
        // 2026-09-28 17:30 UTC is already 2026-09-29 in Taipei (UTC+8).
        let date = Date(timeIntervalSince1970: 1_790_616_600)
        XCTAssertEqual(StudyDay(date, timeZone: try XCTUnwrap(TimeZone(identifier: "UTC"))), StudyDay(year: 2026, month: 9, day: 28))
        XCTAssertEqual(StudyDay(date, timeZone: try XCTUnwrap(TimeZone(identifier: "Asia/Taipei"))), StudyDay(year: 2026, month: 9, day: 29))
    }
}
