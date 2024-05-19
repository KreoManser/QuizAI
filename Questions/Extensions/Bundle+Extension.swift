import Foundation

extension Bundle {
	/// Returns nil if it couldn't find the file
	func fileContent(ofResource name: String?, withExtension ext: String?) -> String? {
		if let url = Bundle.main.url(forResource: name, withExtension: ext), let content = try? String(contentsOf: url) {
			return content
		}
		return nil
	}
}
