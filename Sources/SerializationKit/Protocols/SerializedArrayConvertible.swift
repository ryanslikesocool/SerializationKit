import Foundation

/// The base protocol for an object that can be serialized into an array of elements with the same type.
public protocol SerializedArrayConvertible: Serializable {
	associatedtype SerializedElementType: Serializable

	init(array: [SerializedElementType])
	func toArray() -> [Any]
}

public extension SerializedArrayConvertible {
	func serialize() -> Any {
		SerializationUtility.attemptSerialization(toArray())
	}
}

public extension SerializedArrayConvertible {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let dictionaryArray as [[String: Any]]: self.init(array: dictionaryArray.compactMap { SerializedElementType(unwrap: $0) })
			case let array as [SerializedElementType]: self.init(array: array)
			default: return nil
		}
	}
}

/*
 public extension SerializedArrayConvertible where SerializedElementType: SerializedDictionaryConvertible {
 	init?(unwrap any: Any?) {
 		switch any {
 			case let this as Self: self = this
 			case let dictionaryArray as [[String: Any]]: self.init(array: dictionaryArray.compactMap { SerializedElementType(dictionary: $0) })
 			case let array as [SerializedElementType]: self.init(array: array)
 			default: return nil
 		}
 	}
 }
 */
