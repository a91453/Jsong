import JsongCore
import XCTest

final class BuiltInDataTests: XCTestCase {
    func testEachScriptHasTheFullTable() {
        for type in KanaType.allCases {
            let kana = KanaData.characters(of: type)
            XCTAssertEqual(kana.count, 104, "\(type)")
            XCTAssertEqual(kana.filter { $0.group.kind == .basic }.count, 46, "\(type)")
            XCTAssertEqual(kana.filter { $0.group.kind == .dakuten }.count, 25, "\(type)")
            XCTAssertEqual(kana.filter { $0.group.kind == .combination }.count, 33, "\(type)")
            XCTAssertTrue(kana.allSatisfy { $0.type == type }, "\(type)")
        }
        XCTAssertEqual(KanaData.all, HiraganaData.all + KatakanaData.all)
    }

    func testKanaIDsAreUniqueAndPrefixedByScript() {
        let ids = KanaData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
        for kana in KanaData.all {
            let prefix = kana.type == .hiragana ? "hira_" : "kata_"
            XCTAssertTrue(kana.id.hasPrefix(prefix), kana.id)
        }
    }

    /// Within one script every character and every romaji appears once;
    /// the matching game and the quiz rely on it.
    func testCharactersAndRomajiAreUniqueWithinAScript() {
        for type in KanaType.allCases {
            let kana = KanaData.characters(of: type)
            XCTAssertEqual(Set(kana.map(\.character)).count, kana.count, "\(type)")
            XCTAssertEqual(Set(kana.map(\.romaji)).count, kana.count, "\(type)")
        }
    }

    func testKanaFieldsAreFilledIn() {
        for kana in KanaData.all {
            XCTAssertFalse(kana.character.isEmpty, kana.id)
            XCTAssertFalse(kana.romaji.isEmpty, kana.id)
            XCTAssertTrue(kana.romaji.allSatisfy { $0.isASCII && $0.isLowercase }, kana.id)
            XCTAssertGreaterThan(kana.strokeCount, 0, kana.id)
            XCTAssertFalse(kana.mnemonicHint.isEmpty, kana.id)
        }
    }

    func testKanaGroupsAreInTableOrderAndLookedUpByGroup() {
        for type in KanaType.allCases {
            let kana = KanaData.characters(of: type)
            let order = kana.map { KanaGroup.allCases.firstIndex(of: $0.group)! }
            XCTAssertEqual(order, order.sorted(), "\(type) is not in table order")
            for group in KanaGroup.allCases {
                let lookup = type == .hiragana ? HiraganaData.characters(for: group) : KatakanaData.characters(for: group)
                XCTAssertEqual(lookup, kana.filter { $0.group == group }, "\(type) \(group)")
                XCTAssertFalse(lookup.isEmpty, "\(type) has no \(group)")
            }
        }
    }

    func testVocabularyHasTenWordsPerCategory() {
        XCTAssertEqual(VocabularyData.all.count, 100)
        for category in VocabularyCategory.allCases {
            XCTAssertEqual(VocabularyData.words(for: category).count, 10, "\(category)")
            XCTAssertTrue(VocabularyData.words(for: category).allSatisfy { $0.category == category })
        }
    }

    func testVocabularyIDsAreUniqueAndFieldsFilledIn() {
        let ids = VocabularyData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count)
        for word in VocabularyData.all {
            XCTAssertTrue(word.id.hasPrefix("v_"), word.id)
            for field in [word.japanese, word.reading, word.romaji, word.meaning, word.exampleSentence, word.sentenceMeaning] {
                XCTAssertFalse(field.isEmpty, word.id)
            }
        }
    }
}
