import Foundation
import JsongCore
import XCTest

final class StudyDayTests: XCTestCase {
    func testRejectsDaysThatDoNotExist() {
        XCTAssertNotNil(StudyDay(year: 2024, month: 2, day: 29))
        XCTAssertNotNil(StudyDay(year: 2000, month: 2, day: 29))
        XCTAssertNil(StudyDay(year: 1900, month: 2, day: 29))
        XCTAssertNil(StudyDay(year: 2026, month: 2, day: 29))
        XCTAssertNil(StudyDay(year: 2026, month: 4, day: 31))
        XCTAssertNil(StudyDay(year: 2026, month: 13, day: 1))
        XCTAssertNil(StudyDay(year: 2026, month: 0, day: 1))
        XCTAssertNil(StudyDay(year: 2026, month: 1, day: 0))
        XCTAssertNil(StudyDay(year: 0, month: 1, day: 1))
        XCTAssertNil(StudyDay(year: 10_000, month: 1, day: 1))
    }

    func testDayNumbersCountFromTheUnixEpoch() {
        XCTAssertEqual(day(1970, 1, 1).dayNumber, 0)
        XCTAssertEqual(day(1969, 12, 31).dayNumber, -1)
        XCTAssertEqual(day(2000, 3, 1).dayNumber, 11_017)
        XCTAssertEqual(day(2026, 9, 28).dayNumber, 20_724)
    }

    func testConsecutiveDaysDifferByOne() {
        let pairs = [
            (day(2026, 1, 31), day(2026, 2, 1)),
            (day(2024, 2, 28), day(2024, 2, 29)),
            (day(2024, 2, 29), day(2024, 3, 1)),
            (day(2026, 2, 28), day(2026, 3, 1)),
            (day(2025, 12, 31), day(2026, 1, 1)),
        ]
        for (earlier, later) in pairs {
            XCTAssertEqual(later.dayNumber - earlier.dayNumber, 1, "\(earlier) → \(later)")
            XCTAssertLessThan(earlier, later)
        }
    }

    /// Walking day by day through several leap cycles, the day number goes
    /// up by exactly one each time.
    func testDayNumberIsContinuous() {
        var previous = day(1999, 1, 1).dayNumber
        for year in 1999...2030 {
            for month in 1...12 {
                for dayOfMonth in 1...31 {
                    guard let current = StudyDay(year: year, month: month, day: dayOfMonth) else { continue }
                    if current == day(1999, 1, 1) { continue }
                    XCTAssertEqual(current.dayNumber, previous + 1, "\(current)")
                    previous = current.dayNumber
                }
            }
        }
    }

    func testCodesAsISODate() throws {
        let encoded = try JSONEncoder().encode([day(2026, 9, 8), day(987, 1, 2)])
        XCTAssertEqual(String(decoding: encoded, as: UTF8.self), #"["2026-09-08","0987-01-02"]"#)
        XCTAssertEqual(try JSONDecoder().decode([StudyDay].self, from: encoded), [day(2026, 9, 8), day(987, 1, 2)])
    }

    func testDecodingRejectsMalformedDates() {
        for text in ["2026-9-8", "2026-02-30", "20260908", "2026-09-08T00", "abcd-09-08", "2026-+9-08", "２０２６-09-08", ""] {
            let json = Data("[\"\(text)\"]".utf8)
            XCTAssertThrowsError(try JSONDecoder().decode([StudyDay].self, from: json), text)
        }
    }
}

final class UserProgressTests: XCTestCase {
    func testStreakRules() {
        var progress = UserProgress()
        XCTAssertEqual(progress.streak, 0)
        XCTAssertNil(progress.lastStudyDay)

        progress.recordStudy(on: day(2026, 9, 1))
        XCTAssertEqual(progress.streak, 1)
        progress.recordStudy(on: day(2026, 9, 1))
        XCTAssertEqual(progress.streak, 1, "the same day counts once")
        progress.recordStudy(on: day(2026, 9, 2))
        XCTAssertEqual(progress.streak, 2)
        progress.recordStudy(on: day(2026, 9, 3))
        XCTAssertEqual(progress.streak, 3)

        let beforeClockMovedBack = progress
        progress.recordStudy(on: day(2026, 8, 30))
        XCTAssertEqual(progress, beforeClockMovedBack, "an earlier day changes nothing")

        progress.recordStudy(on: day(2026, 9, 5))
        XCTAssertEqual(progress.streak, 1, "a missed day restarts the streak")
        XCTAssertEqual(progress.lastStudyDay, day(2026, 9, 5))
    }

    func testCurrentStreakLapsesAfterAMissedDay() {
        var progress = UserProgress()
        XCTAssertEqual(progress.currentStreak(on: day(2026, 9, 1)), 0)
        progress.recordStudy(on: day(2026, 9, 1))
        progress.recordStudy(on: day(2026, 9, 2))
        XCTAssertEqual(progress.currentStreak(on: day(2026, 9, 2)), 2)
        XCTAssertEqual(progress.currentStreak(on: day(2026, 9, 3)), 2, "still alive the next day")
        XCTAssertEqual(progress.currentStreak(on: day(2026, 9, 4)), 0)
    }

    func testLearningCountsAsStudyButUnlearningDoesNot() {
        var progress = UserProgress()
        progress.setKana("hira_a", learned: true, on: day(2026, 9, 1))
        XCTAssertTrue(progress.isKanaLearned("hira_a"))
        XCTAssertEqual(progress.lastStudyDay, day(2026, 9, 1))

        progress.setKana("hira_a", learned: false, on: day(2026, 9, 2))
        XCTAssertFalse(progress.isKanaLearned("hira_a"))
        XCTAssertEqual(progress.lastStudyDay, day(2026, 9, 1))

        progress.setVocabulary("v_arigatou", learned: true, on: day(2026, 9, 2))
        XCTAssertTrue(progress.isVocabularyLearned("v_arigatou"))
        XCTAssertEqual(progress.streak, 2)
        progress.setVocabulary("v_arigatou", learned: false, on: day(2026, 9, 3))
        XCTAssertFalse(progress.isVocabularyLearned("v_arigatou"))
        XCTAssertEqual(progress.lastStudyDay, day(2026, 9, 2))
    }

    func testQuizHistoryAndAverage() {
        var progress = UserProgress()
        XCTAssertNil(progress.averageQuizPercentage)
        let first = QuizResult(date: Date(timeIntervalSince1970: 1), type: .kanaToRomaji, questionCount: 10, correctCount: 5)
        let second = QuizResult(date: Date(timeIntervalSince1970: 2), type: .vocabMeaning, questionCount: 10, correctCount: 10)
        progress.recordQuiz(first, on: day(2026, 9, 1))
        progress.recordQuiz(second, on: day(2026, 9, 1))
        XCTAssertEqual(progress.quizHistory, [first, second])
        XCTAssertEqual(progress.averageQuizPercentage, 75)
        XCTAssertEqual(progress.recentQuizzes(limit: 10), [second, first])
        XCTAssertEqual(progress.recentQuizzes(limit: 1), [second])
        XCTAssertEqual(progress.streak, 1)
    }

    func testLearnedCountsIgnoreUnknownIDs() {
        var progress = UserProgress()
        progress.setKana("hira_a", learned: true, on: day(2026, 9, 1))
        progress.setKana("hira_removed", learned: true, on: day(2026, 9, 1))
        progress.setKana("kata_a", learned: true, on: day(2026, 9, 1))
        XCTAssertEqual(progress.learnedCount(of: HiraganaData.all), 1)
        XCTAssertEqual(progress.learnedCount(of: KatakanaData.all), 1)
        progress.setVocabulary("v_arigatou", learned: true, on: day(2026, 9, 1))
        XCTAssertEqual(progress.learnedCount(of: VocabularyData.all), 1)
        XCTAssertEqual(progress.learnedCount(of: VocabularyData.words(for: .numbers)), 0)
    }

    func testCodableRoundTripIsStable() throws {
        var progress = UserProgress()
        for id in ["kata_ka", "hira_a", "hira_ka"] {
            progress.setKana(id, learned: true, on: day(2026, 9, 1))
        }
        progress.setVocabulary("v_arigatou", learned: true, on: day(2026, 9, 2))
        progress.recordQuiz(
            QuizResult(date: Date(timeIntervalSince1970: 1_790_000_000), type: .romajiToKana, questionCount: 10, correctCount: 7),
            on: day(2026, 9, 2)
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .secondsSince1970
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        let data = try encoder.encode(progress)
        XCTAssertEqual(try decoder.decode(UserProgress.self, from: data), progress)
        XCTAssertEqual(try encoder.encode(try decoder.decode(UserProgress.self, from: data)), data, "same bytes every time")
        XCTAssertTrue(String(decoding: data, as: UTF8.self).contains(#""learnedKanaIDs":["hira_a","hira_ka","kata_ka"]"#))
    }

    func testDecodingRejectsAnInconsistentStreak() {
        let base = #""learnedKanaIDs":[],"learnedVocabularyIDs":[],"quizHistory":[]"#
        for body in [#""streak":2"#, #""streak":0,"lastStudyDay":"2026-09-01""#, #""streak":-1"#] {
            let json = Data("{\(base),\(body)}".utf8)
            XCTAssertThrowsError(try JSONDecoder().decode(UserProgress.self, from: json), body)
        }
        let valid = Data("{\(base),\"streak\":0}".utf8)
        XCTAssertEqual(try JSONDecoder().decode(UserProgress.self, from: valid), UserProgress())
    }
}
