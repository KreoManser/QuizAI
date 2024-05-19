import Foundation

class Question: Codable, CustomStringConvertible {

    let id: IntAutoincrementId
    let question: String
    let answers: [String]
    var correctAnswers: Set<UInt8>! = []
    let correct: UInt8?
    var difficulty: Int? // Категория 1 2 3 - Л С Т
    let imageURL: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.question = try container.decode(String.self, forKey: .question)
        self.answers = try container.decode([String].self, forKey: .answers)
        self.correctAnswers = try container.decodeIfPresent(Set<UInt8>.self, forKey: .correctAnswers)
        self.correct = try container.decodeIfPresent(UInt8.self, forKey: .correct)
        self.difficulty = try container.decodeIfPresent(Int.self, forKey: .difficulty)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.id = IntAutoincrementId()
    }

    init(question: String, answers: [String], correct: Set<UInt8>, singleCorrect: UInt8? = nil, difficulty: Int? = nil, imageURL: String? = nil) {
        self.id = IntAutoincrementId()
        self.question = question.trimmingCharacters(in: .whitespacesAndNewlines)
        self.answers = answers.map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        self.correctAnswers = correct
        self.correct = singleCorrect
        self.difficulty = difficulty
        self.imageURL = imageURL?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var description: String {
        return "\(id.getId()): \(question)"
    }
}

extension Question: Equatable {
    static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.question == rhs.question && lhs.answers == rhs.answers && lhs.correctAnswers == rhs.correctAnswers
    }
}

extension Question: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.question.hash)
    }
}
