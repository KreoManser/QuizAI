import UIKit

struct ToastAlert {
	
	struct Length {
		let timeInterval: DispatchTimeInterval
		static let short = Length(timeInterval: .milliseconds(250))
		static let long = Length(timeInterval: .milliseconds(500))
	}
	
	private let alertController: UIAlertController
	private let length: ToastAlert.Length
	
	@discardableResult
	static func present(message: String, withLength length: ToastAlert.Length, in viewController: UIViewController, onCompletion: @escaping () -> () = {}) -> Bool {
		return ToastAlert.makeWith(message: message, length: length).present(in: viewController, onCompletion: onCompletion)
	}
	
	/// You must put UI code inside `DispatchQueue.main.async {}` in `operation` parameter
	static func present(
        onSuccess onSuccessMessage: String,
        onError onErrorMessage: String,
        withLength length: ToastAlert.Length,
        in viewController: UIViewController,
        operation: @escaping () -> Bool, onCompletion: @escaping () -> () = {}) {

		DispatchQueue.global().async {
			let operationSuccess = operation()
			DispatchQueue.main.async {
				ToastAlert.makeWith(message: operationSuccess ? onSuccessMessage : onErrorMessage, length: length).present(in: viewController, onCompletion: onCompletion)
			}
		}
	}
	
	/// You must put UI code inside `DispatchQueue.main.async {}` in `operation` parameter
	static func presentAsynchronously(message: String, withLength length: ToastAlert.Length, in viewController: UIViewController,
						operation: @escaping () -> (), onCompletion: @escaping () -> () = {}) {
		
		DispatchQueue.global().async {
			operation()
			DispatchQueue.main.async {
				ToastAlert.makeWith(message: message, length: length).present(in: viewController, onCompletion: onCompletion)
			}
		}
	}
	
	static func makeWith(message: String, length: ToastAlert.Length) -> ToastAlert {
		return ToastAlert(alertController: UIAlertController(title: nil, message: NSLocalizedString(message, comment: ""), preferredStyle: .alert),
						  length: length)
	}
	
	@discardableResult
	func present(in viewController: UIViewController, onCompletion: @escaping () -> () = {}) -> Bool {
		
		guard viewController.presentedViewController == nil else { return false }
		
		viewController.present(self.alertController, animated: true) {
			DispatchQueue.main.asyncAfter(deadline: .now() + self.length.timeInterval) {
				self.alertController.dismiss(animated: true, completion: onCompletion)
			}
		}
		return true
	}
}
