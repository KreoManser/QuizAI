import Foundation

protocol ApplyProtocol { }
extension ApplyProtocol {
	@discardableResult
	func apply(closure: (Self) -> ()) -> Self {
		closure(self)
		return self
	}
}
