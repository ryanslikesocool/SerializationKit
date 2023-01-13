import Foundation

public extension SerializedObject where Self: LosslessStringConvertible {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let str as any StringProtocol:
				if let this = Self(String(str)) {
					self = this
				} else {
					fallthrough
				}
			default: return nil
		}
	}
}
