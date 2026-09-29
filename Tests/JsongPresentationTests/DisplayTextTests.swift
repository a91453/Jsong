import JsongCore
import JsongPresentation
import XCTest

final class DisplayTextTests: XCTestCase {
    private func assertUniqueTitles<T>(_ values: [T], _ title: (T) -> String, file: StaticString = #filePath, line: UInt = #line) {
        let titles = values.map(title)
        XCTAssertTrue(titles.allSatisfy { !$0.isEmpty }, file: file, line: line)
        XCTAssertEqual(Set(titles).count, titles.count, "\(titles)", file: file, line: line)
    }

    func testEveryValueHasItsOwnTitle() {
        assertUniqueTitles(KanaType.allCases, \.title)
        assertUniqueTitles(KanaGroup.allCases, \.title)
        assertUniqueTitles(KanaGroup.Kind.allCases, \.title)
        assertUniqueTitles(VocabularyCategory.allCases, \.title)
        assertUniqueTitles(QuizType.allCases, \.title)
        assertUniqueTitles(QuizType.allCases, \.subtitle)
        assertUniqueTitles(QuizGrade.allCases, \.title)
        assertUniqueTitles(EchoPhase.allCases, \.title)
        assertUniqueTitles(EchoPhase.allCases, \.instruction)
    }

    func testPercent() {
        XCTAssertEqual(DisplayText.percent(0), "0%")
        XCTAssertEqual(DisplayText.percent(1), "100%")
        XCTAssertEqual(DisplayText.percent(DisplayText.fraction(29, of: 100)), "29%")
        XCTAssertEqual(DisplayText.percent(DisplayText.fraction(57, of: 100)), "57%")
        XCTAssertEqual(DisplayText.percent(0.996), "99%", "only complete is 100%")
        XCTAssertEqual(DisplayText.percent(-0.5), "0%")
        XCTAssertEqual(DisplayText.percent(1.5), "100%")
    }

    func testFraction() {
        XCTAssertEqual(DisplayText.fraction(1, of: 4), 0.25)
        XCTAssertEqual(DisplayText.fraction(3, of: 0), 0)
    }
}
