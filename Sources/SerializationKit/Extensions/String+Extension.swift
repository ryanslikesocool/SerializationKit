import Foundation

public extension String {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let str as any StringProtocol: self = String(str)
			default: return nil
		}
	}

	func serialize() -> Any { self }
}
