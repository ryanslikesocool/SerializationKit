import Foundation

public extension Date {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let dbl as Double: self = Date(timeIntervalSince1970: dbl)
			case let str as any StringProtocol:
				if let date = try? Self(str, strategy: .iso8601) {
					self = date
				} else {
					fallthrough
				}
			default: return nil
		}
	}

	func serialize() -> Any { timeIntervalSince1970 }
}
