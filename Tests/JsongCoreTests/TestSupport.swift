import JsongCore

/// A small deterministic generator (SplitMix64), so shuffles in tests are
/// the same on every run. Tests compare runs with the same seed; they never
/// hard-code a shuffled order, which the standard library does not promise
/// to keep across Swift versions.
struct SplitMix64: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

/// Seeds every randomized test runs with. Fixed: CI never picks new ones.
let testSeeds: [UInt64] = [0x5EED_0001, 0x5EED_0002, 0x5EED_0003, 0x5EED_0004, 0x5EED_0005]

func day(_ year: Int, _ month: Int, _ day: Int) -> StudyDay {
    guard let value = StudyDay(year: year, month: month, day: day) else {
        preconditionFailure("\(year)-\(month)-\(day) is not a valid test day")
    }
    return value
}
