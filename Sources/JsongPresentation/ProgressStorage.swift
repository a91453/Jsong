import Foundation
import JsongCore

/// Where `ProgressStore` keeps the encoded progress.
public protocol ProgressStorage {
    /// The saved bytes, or nil if nothing was saved yet.
    func load() -> Data?
    func save(_ data: Data)
    /// Keeps saved bytes that could not be decoded, so a later version can
    /// still recover them before new progress replaces them.
    func preserveUnreadable(_ data: Data)
}

/// Stores progress in `UserDefaults`.
public struct UserDefaultsProgressStorage: ProgressStorage {
    public static let key = "progress.v1"
    public static let unreadableKey = "progress.v1.unreadable"

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func load() -> Data? {
        defaults.data(forKey: Self.key)
    }

    public func save(_ data: Data) {
        defaults.set(data, forKey: Self.key)
    }

    public func preserveUnreadable(_ data: Data) {
        defaults.set(data, forKey: Self.unreadableKey)
    }
}

/// Keeps progress in memory only; for previews, tests and demo launches.
public final class InMemoryProgressStorage: ProgressStorage {
    public private(set) var data: Data?
    public private(set) var unreadable: Data?

    public init(data: Data? = nil) {
        self.data = data
    }

    public func load() -> Data? { data }

    public func save(_ data: Data) {
        self.data = data
    }

    public func preserveUnreadable(_ data: Data) {
        unreadable = data
    }
}

/// The saved form of `UserProgress`: JSON with sorted keys and dates as
/// seconds since 1970.
public enum ProgressCoding {
    public static func encode(_ progress: UserProgress) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .secondsSince1970
        return try encoder.encode(progress)
    }

    public static func decode(_ data: Data) throws -> UserProgress {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(UserProgress.self, from: data)
    }
}
