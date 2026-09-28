import Foundation
import JsongCore
import XCTest

final class QuizGeneratorTests: XCTestCase {
    func testQuestionsHaveDistinctPromptsAndFourUniqueChoices() {
        for type in QuizType.allCases {
            for seed in testSeeds {
                var generator = SplitMix64(seed: seed)
                let questions = QuizGenerator.questions(for: type, count: 10, using: &generator)
                XCTAssertEqual(questions.count, 10, "\(type) seed \(seed)")
                XCTAssertEqual(Set(questions.map(\.prompt)).count, questions.count, "\(type) seed \(seed)")
                for question in questions {
                    XCTAssertEqual(question.type, type)
                    XCTAssertEqual(question.choices.count, QuizGenerator.choiceCount, "\(question)")
                    XCTAssertEqual(Set(question.choices).count, question.choices.count, "\(question)")
                    XCTAssertTrue(question.choices.contains(question.answer), "\(question)")
                }
            }
        }
    }

    /// No distractor may be another correct answer for the prompt.
    func testDistractorsAreNeverCorrectForThePrompt() {
        for type in QuizType.allCases {
            let items = QuizGenerator.items(for: type)
            for seed in testSeeds {
                var generator = SplitMix64(seed: seed)
                for question in QuizGenerator.questions(for: type, count: 50, using: &generator) {
                    let correct = Set(items.filter { $0.prompt == question.prompt }.map(\.answer))
                    XCTAssertTrue(correct.contains(question.answer), "\(question)")
                    let wrong = question.choices.filter { $0 != question.answer }
                    XCTAssertTrue(correct.isDisjoint(with: wrong), "\(question) offers another correct answer")
                }
            }
        }
    }

    /// Regression for the prototype: romaji "ka" is both か and カ, so a
    /// か question must not offer カ.
    func testRomajiQuestionNeverOffersTheOtherScript() {
        let items = [
            QuizGenerator.Item(prompt: "ka", answer: "か"),
            QuizGenerator.Item(prompt: "ka", answer: "カ"),
            QuizGenerator.Item(prompt: "sa", answer: "さ"),
            QuizGenerator.Item(prompt: "ta", answer: "た"),
            QuizGenerator.Item(prompt: "na", answer: "な"),
        ]
        for seed in testSeeds {
            var generator = SplitMix64(seed: seed)
            let questions = QuizGenerator.questions(for: .romajiToKana, from: items, count: 10, using: &generator)
            guard let ka = questions.first(where: { $0.prompt == "ka" }) else {
                XCTFail("no question for ka, seed \(seed)")
                continue
            }
            XCTAssertEqual(ka.choices.filter { $0 == "か" || $0 == "カ" }.count, 1, "\(ka)")
        }
    }

    func testFewerDistractorsWhenThePoolIsSmall() {
        let items = [
            QuizGenerator.Item(prompt: "a", answer: "1"),
            QuizGenerator.Item(prompt: "b", answer: "2"),
        ]
        var generator = SplitMix64(seed: 1)
        let questions = QuizGenerator.questions(for: .kanaToRomaji, from: items, count: 5, using: &generator)
        XCTAssertEqual(questions.count, 2, "one question per distinct prompt")
        XCTAssertTrue(questions.allSatisfy { $0.choices.count == 2 })
    }

    func testDistractorsVaryBetweenQuestions() {
        var generator = SplitMix64(seed: testSeeds[0])
        let questions = QuizGenerator.questions(for: .kanaToRomaji, count: 10, using: &generator)
        let wrongChoices = Set(questions.flatMap { question in question.choices.filter { $0 != question.answer } })
        XCTAssertGreaterThan(wrongChoices.count, 3, "every question got the same distractors")
    }

    func testSameSeedGivesSameQuestions() {
        for type in QuizType.allCases {
            var first = SplitMix64(seed: 42)
            var second = SplitMix64(seed: 42)
            XCTAssertEqual(
                QuizGenerator.questions(for: type, count: 10, using: &first),
                QuizGenerator.questions(for: type, count: 10, using: &second)
            )
        }
    }

    func testZeroCountGivesNoQuestions() {
        var generator = SplitMix64(seed: 1)
        XCTAssertTrue(QuizGenerator.questions(for: .vocabMeaning, count: 0, using: &generator).isEmpty)
    }
}

final class QuizSessionTests: XCTestCase {
    private func makeSession() -> QuizSession {
        QuizSession(type: .kanaToRomaji, questions: [
            QuizQuestion(type: .kanaToRomaji, prompt: "あ", answer: "a", choices: ["i", "a", "u", "e"]),
            QuizQuestion(type: .kanaToRomaji, prompt: "か", answer: "ka", choices: ["ka", "ki", "ku", "ke"]),
        ])
    }

    func testScoresCorrectAnswersAndFinishes() {
        var session = makeSession()
        XCTAssertEqual(session.currentQuestion?.prompt, "あ")
        XCTAssertEqual(session.progress, 0)
        XCTAssertEqual(session.answer("a"), true)
        XCTAssertTrue(session.isAnswered)
        session.advance()
        XCTAssertEqual(session.progress, 0.5)
        XCTAssertEqual(session.answer("ki"), false)
        session.advance()
        XCTAssertTrue(session.isFinished)
        XCTAssertNil(session.currentQuestion)
        XCTAssertEqual(session.correctCount, 1)
        XCTAssertEqual(session.progress, 1)

        let date = Date(timeIntervalSince1970: 1_000)
        XCTAssertEqual(
            session.result(on: date),
            QuizResult(date: date, type: .kanaToRomaji, questionCount: 2, correctCount: 1)
        )
    }

    func testIgnoresASecondAnswerAndUnknownChoices() {
        var session = makeSession()
        XCTAssertNil(session.answer("ka"), "not a choice of this question")
        XCTAssertFalse(session.isAnswered)
        XCTAssertEqual(session.answer("i"), false)
        let before = session
        XCTAssertNil(session.answer("a"))
        XCTAssertEqual(session, before)
    }

    func testAdvanceNeedsAnAnswer() {
        var session = makeSession()
        let before = session
        session.advance()
        XCTAssertEqual(session, before)
    }

    func testNoResultBeforeTheEndOrWithoutQuestions() {
        var session = makeSession()
        session.answer("a")
        session.advance()
        XCTAssertNil(session.result(on: Date()))

        let empty = QuizSession(type: .vocabMeaning, questions: [])
        XCTAssertTrue(empty.isFinished)
        XCTAssertNil(empty.result(on: Date()))
    }

    func testRandomSessionUsesTheGenerator() {
        var generator = SplitMix64(seed: 7)
        let session = QuizSession(type: .meaningToVocab, questionCount: 10, using: &generator)
        XCTAssertEqual(session.questions.count, 10)
        XCTAssertEqual(session.type, .meaningToVocab)
    }
}

final class QuizResultTests: XCTestCase {
    func testGradeBoundaries() {
        let date = Date(timeIntervalSince1970: 0)
        func grade(_ correct: Int, of total: Int) -> QuizGrade {
            QuizResult(date: date, type: .kanaToRomaji, questionCount: total, correctCount: correct).grade
        }
        XCTAssertEqual(grade(10, of: 10), .excellent)
        XCTAssertEqual(grade(9, of: 10), .excellent)
        XCTAssertEqual(grade(8, of: 10), .good)
        XCTAssertEqual(grade(7, of: 10), .good)
        XCTAssertEqual(grade(6, of: 10), .fair)
        XCTAssertEqual(grade(5, of: 10), .fair)
        XCTAssertEqual(grade(4, of: 10), .needsReview)
        XCTAssertEqual(grade(0, of: 10), .needsReview)
        XCTAssertEqual(grade(2, of: 3), .fair, "66.7 %")
    }

    func testPercentage() {
        let result = QuizResult(date: Date(timeIntervalSince1970: 0), type: .vocabMeaning, questionCount: 4, correctCount: 3)
        XCTAssertEqual(result.percentage, 75)
    }

    func testDecodingRejectsImpossibleCounts() throws {
        let decoder = JSONDecoder()
        for (total, correct) in [(0, 0), (10, 11), (10, -1)] {
            let json = #"{"date":0,"type":"kanaToRomaji","questionCount":\#(total),"correctCount":\#(correct)}"#
            XCTAssertThrowsError(try decoder.decode(QuizResult.self, from: Data(json.utf8)), "\(total) \(correct)")
        }
        let valid = #"{"date":0,"type":"kanaToRomaji","questionCount":10,"correctCount":10}"#
        XCTAssertEqual(try decoder.decode(QuizResult.self, from: Data(valid.utf8)).correctCount, 10)
    }
}
