import Foundation

struct QuestionWithAnswersForm: Codable {

	struct Answer: Codable {
		let answer: String
		let isCorrect: Bool
	}
	
	let question: String
	let questionImage: String?
    let difficulty: Int
	let answers: [Answer]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)
        questionImage = try container.decodeIfPresent(String.self, forKey: .questionImage)
        let difficultyString = try container.decode(String.self, forKey: .difficulty)
        difficulty = QuestionWithAnswersForm.difficulty(from: difficultyString)
        answers = try container.decode([Answer].self, forKey: .answers)
    }

    private static func difficulty(from string: String) -> Int {
        switch string.lowercased() {
        case "Easy":
            return 1
        case "Medium":
            return 2
        case "Hard":
            return 3
        default:
            return 0
        }
    }
}

typealias QuestionsWithAnswersIDs = [(questionID: String, questionImageID: String, difficultyID: String, answerIDs: [(answerValueID: String, isAnswerCorrectID: String)])]
