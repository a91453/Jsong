/// A calendar day in the learner's own time zone, as a Gregorian date.
///
/// Daily streaks compare days, not instants. Converting a `Date` to a
/// `StudyDay` needs a calendar and a time zone, so it happens in
/// JsongPresentation; here days are plain values, which keeps streak rules
/// deterministic and testable.
public struct StudyDay: Hashable, Comparable, Sendable {
    public let year: Int
    public let month: Int
    public let day: Int

    /// Nil unless the date exists in the Gregorian calendar and the year is
    /// 1…9999.
    public init?(year: Int, month: Int, day: Int) {
        guard (1...9999).contains(year), (1...12).contains(month),
              (1...Self.daysInMonth(month, year: year)).contains(day) else {
            return nil
        }
        self.year = year
        self.month = month
        self.day = day
    }

    /// Days since 1970-01-01 (negative before it). Consecutive days differ
    /// by exactly 1, across month and year ends.
    public var dayNumber: Int {
        // Howard Hinnant's days_from_civil, for the proleptic Gregorian calendar.
        let y = month <= 2 ? year - 1 : year
        let era = (y >= 0 ? y : y - 399) / 400
        let yearOfEra = y - era * 400
        let dayOfYear = (153 * (month + (month > 2 ? -3 : 9)) + 2) / 5 + day - 1
        let dayOfEra = yearOfEra * 365 + yearOfEra / 4 - yearOfEra / 100 + dayOfYear
        return era * 146_097 + dayOfEra - 719_468
    }

    public static func < (lhs: StudyDay, rhs: StudyDay) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    static func daysInMonth(_ month: Int, year: Int) -> Int {
        switch month {
        case 2:
            let isLeap = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
            return isLeap ? 29 : 28
        case 4, 6, 9, 11:
            return 30
        default:
            return 31
        }
    }
}

extension StudyDay: Codable {
    /// Encoded as `yyyy-MM-dd`.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        let parts = text.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 3, parts[0].count == 4, parts[1].count == 2, parts[2].count == 2,
              parts.allSatisfy({ $0.allSatisfy(\.isASCII) && $0.allSatisfy(\.isNumber) }),
              let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]),
              let value = StudyDay(year: year, month: month, day: day) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected a valid yyyy-MM-dd date, got \(text).")
        }
        self = value
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension StudyDay: CustomStringConvertible {
    /// `yyyy-MM-dd`.
    public var description: String {
        func padded(_ value: Int, _ width: Int) -> String {
            let digits = String(value)
            return String(repeating: "0", count: max(0, width - digits.count)) + digits
        }
        return "\(padded(year, 4))-\(padded(month, 2))-\(padded(day, 2))"
    }
}
