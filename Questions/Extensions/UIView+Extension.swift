import UIKit

extension UIView {
	
	func dontInvertIfDarkModeIsEnabled() {
		if #available(iOS 13.0, *) {
			self.accessibilityIgnoresInvertColors = UserDefaultsManager.darkThemeSwitchIsOn
		}
	}
	
	func dontInvertColors() {
		if #available(iOS 13.0, *) {
			self.accessibilityIgnoresInvertColors = true
		}
	}
}
