import Foundation
import JsongCore
import Observation

/// Owns the app's single `UserProgress`, saves it after every change, and
/// supplies today's `StudyDay`.
///
/// Views read `progress` and change it only through these methods.
@MainActor
@Observable
public final class ProgressStore {
    public private(set) var progress: UserProgress

    private let storage: any ProgressStorage
    private let today: () -> StudyDay

    /// Loads saved progress from `storage`.
    ///
    /// Saved data that cannot be read (damaged, or from an incompatible
    /// version) is handed to `storage.preserveUnreadable(_:)` instead of
    /// being overwritten, and the store starts empty.
    public init(storage: any ProgressStorage, today: @escaping () -> StudyDay = { StudyDay(Date(), timeZone: .current) }) {
        self.storage = storage
        self.today = today
        if let data = storage.load() {
            do {
                progress = try ProgressCoding.decode(data)
            } catch {
                storage.preserveUnreadable(data)
                progress = UserProgress()
            }
        } else {
            progress = UserProgress()
        }
    }

    /// The streak as of today (0 once a day was missed).
    public var currentStreak: Int {
        progress.currentStreak(on: today())
    }

    public func setKana(_ id: String, learned: Bool) {
        progress.setKana(id, learned: learned, on: today())
        save()
    }

    public func toggleKana(_ id: String) {
        setKana(id, learned: !progress.isKanaLearned(id))
    }

    public func setVocabulary(_ id: String, learned: Bool) {
        progress.setVocabulary(id, learned: learned, on: today())
        save()
    }

    public func toggleVocabulary(_ id: String) {
        setVocabulary(id, learned: !progress.isVocabularyLearned(id))
    }

    public func recordQuiz(_ result: QuizResult) {
        progress.recordQuiz(result, on: today())
        save()
    }

    private func save() {
        do {
            storage.save(try ProgressCoding.encode(progress))
        } catch {
            // UserProgress holds only strings, integers, dates and valid
            // days, so encoding cannot fail.
            assertionFailure("Could not encode progress: \(error)")
        }
    }
}

extension StudyDay {
    /// The Gregorian day that `date` falls on in `timeZone`.
    ///
    /// Always Gregorian, whatever calendar the device is set to (a Japanese
    /// or Buddhist calendar would give other year numbers).
    public init(_ date: Date, timeZone: TimeZone) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day,
              let studyDay = StudyDay(year: year, month: month, day: day) else {
            preconditionFailure("\(date) is outside the supported years 1...9999.")
        }
        self = studyDay
    }
}
