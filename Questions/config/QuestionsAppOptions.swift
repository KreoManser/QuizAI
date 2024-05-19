import Foundation

struct QuestionsAppOptions {
    static let correctAnswerPoints: Int = Int.random(in: 15...20)
    static let incorrectAnswerPoints: Int = Int.random(in: -20...0)
	static let helpActionPoints: Int = -5
	
	static let maximumHelpTries: UInt8 = 2
	static let isHelpEnabled: Bool = true
	
	static let maximumRepeatTriesPerQuiz: UInt8 = 2
	
	static let privacyFeaturesEnabled: Bool = false
	
	static let communityTopicsURL: String = "https://pastebin.com/raw/hgmNQ0xh"
}
