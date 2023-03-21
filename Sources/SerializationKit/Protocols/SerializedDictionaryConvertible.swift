import Foundation

/// The base protocol for an object that can be serialized into a dictionary.
public protocol SerializedDictionaryConvertible: Serializable {
	init(dictionary: [String: Any])
	func toDictionary() -> [String: Any?]
}

public extension SerializedDictionaryConvertible {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let dictionary as [String: Any]: self.init(dictionary: dictionary)
			default: return nil
		}
	}

	func serialize() -> Any {
		let dictionary = toDictionary().compactMapValues { $0 }
		return SerializationUtility.attemptSerialization(dictionary)
	}
}
