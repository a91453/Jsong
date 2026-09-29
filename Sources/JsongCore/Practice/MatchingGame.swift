/// A matching game: kana on the left, their romaji on the right, shuffled;
/// the learner picks one card on each side to make a pair.
public struct MatchingGame: Hashable, Sendable {
    public struct Card: Identifiable, Hashable, Sendable {
        /// Unique within the game.
        public let id: Int
        public let text: String
        /// The ID of the kana the card belongs to; the two cards of a pair
        /// share it.
        public let pairID: String
    }

    public enum Side: Hashable, Sendable {
        case left
        case right
    }

    public enum Outcome: Hashable, Sendable {
        /// A card is selected; waiting for one on the other side.
        case selected
        /// The two selected cards form a pair and are now matched.
        case matched(pairID: String)
        /// The two selected cards do not match; both are deselected.
        case mismatched(left: Int, right: Int)
    }

    /// Kana cards, shuffled.
    public let left: [Card]
    /// Romaji cards, shuffled independently.
    public let right: [Card]
    public private(set) var selectedLeft: Int?
    public private(set) var selectedRight: Int?
    public private(set) var matchedPairIDs: Set<String> = []
    /// Number of completed two-card picks, matched or not.
    public private(set) var attempts = 0

    /// A game of up to `pairCount` pairs from `kana`.
    ///
    /// Only kana whose character and romaji both differ from every other
    /// chosen kana are used, so each card has exactly one partner.
    public init<R: RandomNumberGenerator>(kana: [KanaCharacter], pairCount: Int, using generator: inout R) {
        precondition(pairCount >= 0, "pairCount must not be negative.")
        var chosen: [KanaCharacter] = []
        var characters: Set<String> = []
        var romaji: Set<String> = []
        for candidate in kana.shuffled(using: &generator) where chosen.count < pairCount {
            guard !characters.contains(candidate.character), !romaji.contains(candidate.romaji) else { continue }
            characters.insert(candidate.character)
            romaji.insert(candidate.romaji)
            chosen.append(candidate)
        }
        let count = chosen.count
        left = chosen.enumerated()
            .map { Card(id: $0.offset, text: $0.element.character, pairID: $0.element.id) }
            .shuffled(using: &generator)
        right = chosen.enumerated()
            .map { Card(id: count + $0.offset, text: $0.element.romaji, pairID: $0.element.id) }
            .shuffled(using: &generator)
    }

    public var pairCount: Int { left.count }

    public var matchedCount: Int { matchedPairIDs.count }

    public var isComplete: Bool { !left.isEmpty && matchedPairIDs.count == left.count }

    public func isMatched(_ card: Card) -> Bool {
        matchedPairIDs.contains(card.pairID)
    }

    /// Selects the card `id` on `side`, replacing an earlier selection on
    /// that side. When both sides then have a selection it counts as an
    /// attempt and both are deselected.
    ///
    /// Returns nil and changes nothing if the card is not on that side or is
    /// already matched.
    @discardableResult
    public mutating func select(_ id: Int, on side: Side) -> Outcome? {
        let cards = side == .left ? left : right
        guard let card = cards.first(where: { $0.id == id }), !isMatched(card) else { return nil }
        switch side {
        case .left: selectedLeft = id
        case .right: selectedRight = id
        }
        guard let leftID = selectedLeft, let rightID = selectedRight,
              let leftCard = left.first(where: { $0.id == leftID }),
              let rightCard = right.first(where: { $0.id == rightID }) else {
            return .selected
        }
        attempts += 1
        selectedLeft = nil
        selectedRight = nil
        if leftCard.pairID == rightCard.pairID {
            matchedPairIDs.insert(leftCard.pairID)
            return .matched(pairID: leftCard.pairID)
        }
        return .mismatched(left: leftID, right: rightID)
    }
}
