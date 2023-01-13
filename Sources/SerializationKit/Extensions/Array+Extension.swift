import Foundation

extension Array: SerializedArrayConvertible & Serializable where Element: SerializedObjectConvertible {
	public init(array: [Element]) {
		self = array
	}

	public func toArray() -> [Any] { self }

	public func serialize() -> Any {
		map { $0.serialize() }
	}
}
