import Foundation

/// The base protocol for an object that can be serialized into a `[String: any SerializedObject]` dictionary.
public protocol SerializedDictionaryConvertible: SerializedObject {
    init(dictionary: SerializedDictionary)
    func toDictionary() -> SerializedDictionary
}

public extension SerializedDictionaryConvertible {
	init?(unwrap any: Any?) {
		switch any {
			case let this as Self: self = this
			case let dictionary as SerializedDictionary: self.init(dictionary: dictionary)
			default: return nil
		}
	}
}
