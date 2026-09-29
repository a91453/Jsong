import JsongCore
import XCTest

final class EchoSessionTests: XCTestCase {
    private let words = Array(VocabularyData.all.prefix(2))

    func testWalksThroughEveryPhaseThenTheNextWord() {
        var session = EchoSession(words: words)
        XCTAssertEqual(session.currentWord, words[0])
        XCTAssertEqual(session.phase, .see)
        for expected in EchoPhase.allCases.dropFirst() {
            session.advancePhase()
            XCTAssertEqual(session.phase, expected)
        }
        let atRecall = session
        session.advancePhase()
        XCTAssertEqual(session, atRecall, "recall is the last phase")

        XCTAssertEqual(session.finishWord(remembered: true), words[0])
        XCTAssertEqual(session.currentWord, words[1])
        XCTAssertEqual(session.phase, .see)
    }

    func testFinishingNeedsTheRecallPhase() {
        var session = EchoSession(words: words)
        let before = session
        XCTAssertNil(session.finishWord(remembered: true))
        XCTAssertEqual(session, before)
    }

    func testForgottenWordIsNotReturnedAndTheSessionEnds() {
        var session = EchoSession(words: [words[0]])
        for _ in EchoPhase.allCases { session.advancePhase() }
        XCTAssertNil(session.finishWord(remembered: false))
        XCTAssertTrue(session.isFinished)
        XCTAssertNil(session.currentWord)

        let finished = session
        session.advancePhase()
        XCTAssertNil(session.finishWord(remembered: true))
        XCTAssertEqual(session, finished)
    }

    func testRandomSessionPicksDistinctWords() {
        for seed in testSeeds {
            var generator = SplitMix64(seed: seed)
            let session = EchoSession(wordCount: 10, using: &generator)
            XCTAssertEqual(session.words.count, 10)
            XCTAssertEqual(Set(session.words.map(\.id)).count, 10)
        }
        var generator = SplitMix64(seed: 1)
        XCTAssertEqual(EchoSession(wordCount: 500, using: &generator).words.count, VocabularyData.all.count)
    }
}

final class MatchingGameTests: XCTestCase {
    private func basicHiragana() -> [KanaCharacter] {
        HiraganaData.all.filter { $0.group.kind == .basic }
    }

    func testDealsUniquePairs() {
        for seed in testSeeds {
            var generator = SplitMix64(seed: seed)
            let game = MatchingGame(kana: basicHiragana(), pairCount: 6, using: &generator)
            XCTAssertEqual(game.pairCount, 6)
            XCTAssertEqual(game.right.count, 6)
            XCTAssertEqual(Set(game.left.map(\.pairID)), Set(game.right.map(\.pairID)))
            XCTAssertEqual(Set(game.left.map(\.text)).count, 6)
            XCTAssertEqual(Set(game.right.map(\.text)).count, 6)
            XCTAssertEqual(Set((game.left + game.right).map(\.id)).count, 12)
        }
    }

    /// Hiragana and katakana share romaji; a mixed deck must still give
    /// every card exactly one partner.
    func testSkipsKanaThatWouldMakeAmbiguousPairs() {
        for seed in testSeeds {
            var generator = SplitMix64(seed: seed)
            let game = MatchingGame(kana: KanaData.all, pairCount: 20, using: &generator)
            XCTAssertEqual(Set(game.right.map(\.text)).count, game.right.count)
            XCTAssertEqual(Set(game.left.map(\.text)).count, game.left.count)
        }
        let duplicates = [HiraganaData.all[0], KatakanaData.all[0]]  // あ and ア are both "a"
        var generator = SplitMix64(seed: 1)
        XCTAssertEqual(MatchingGame(kana: duplicates, pairCount: 2, using: &generator).pairCount, 1)
    }

    func testMatchAndMismatch() throws {
        var generator = SplitMix64(seed: 3)
        var game = MatchingGame(kana: basicHiragana(), pairCount: 3, using: &generator)
        let first = game.left[0]
        let partner = try XCTUnwrap(game.right.first { $0.pairID == first.pairID })
        let stranger = try XCTUnwrap(game.right.first { $0.pairID != first.pairID })

        XCTAssertEqual(game.select(first.id, on: .left), .selected)
        XCTAssertEqual(game.select(stranger.id, on: .right), .mismatched(left: first.id, right: stranger.id))
        XCTAssertEqual(game.attempts, 1)
        XCTAssertNil(game.selectedLeft)
        XCTAssertNil(game.selectedRight)

        XCTAssertEqual(game.select(partner.id, on: .right), .selected)
        XCTAssertEqual(game.select(first.id, on: .left), .matched(pairID: first.pairID))
        XCTAssertEqual(game.attempts, 2)
        XCTAssertTrue(game.isMatched(first))
        XCTAssertTrue(game.isMatched(partner))

        let before = game
        XCTAssertNil(game.select(first.id, on: .left), "already matched")
        XCTAssertNil(game.select(first.id, on: .right), "not a right-side card")
        XCTAssertNil(game.select(999, on: .left))
        XCTAssertEqual(game, before)
    }

    func testReselectingOnOneSideReplacesTheSelection() {
        var generator = SplitMix64(seed: 4)
        var game = MatchingGame(kana: basicHiragana(), pairCount: 3, using: &generator)
        game.select(game.left[0].id, on: .left)
        game.select(game.left[1].id, on: .left)
        XCTAssertEqual(game.selectedLeft, game.left[1].id)
        XCTAssertEqual(game.attempts, 0)
    }

    func testCompletesWhenEveryPairIsMatched() {
        var generator = SplitMix64(seed: 5)
        var game = MatchingGame(kana: basicHiragana(), pairCount: 4, using: &generator)
        for card in game.left {
            XCTAssertFalse(game.isComplete)
            let partner = game.right.first { $0.pairID == card.pairID }!
            game.select(card.id, on: .left)
            game.select(partner.id, on: .right)
        }
        XCTAssertTrue(game.isComplete)
        XCTAssertEqual(game.matchedCount, 4)
        XCTAssertEqual(game.attempts, 4)
    }

    func testSameSeedDealsTheSameGame() {
        var first = SplitMix64(seed: 9)
        var second = SplitMix64(seed: 9)
        XCTAssertEqual(
            MatchingGame(kana: basicHiragana(), pairCount: 6, using: &first),
            MatchingGame(kana: basicHiragana(), pairCount: 6, using: &second)
        )
    }
}
