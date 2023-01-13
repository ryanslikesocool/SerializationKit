import Foundation

extension Array: SerializedArrayConvertible & Serializable where Element: Serializable {
	public init(array: [Element]) {
		self = array
	}

	public func toArray() -> [Any] { self }

	public func serialize() -> Any {
		map { $0.serialize() }
	}
}

//extension Array: SerializedArrayConvertible & Serializable where Element: SerializedDictionaryConvertible {
//	public init?(unwrap any: Any?) {
//		guard let array = any as? [[String: Any]] else {
//			return nil
//		}
//
//		let elements = array.map { dict in
//			Element(dictionary: dict)
//		}
//
//		self.init(elements)
//	}
//
//	public func toArray() -> [[String: Any]] {
//		map { $0.serialize() }
//	}
//}
