import Foundation

public struct SerializationUtility {
    private init() { }
}

public extension SerializationUtility {
	static func toPlistData(_ serializedDictionary: any SerializedDictionaryConvertible, format: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let dictionary = serializedDictionary.serialize()
		return try PropertyListSerialization.data(fromPropertyList: dictionary, format: format, options: 0)
	}

	static func toJsonData(_ serializedDictionary: any SerializedDictionaryConvertible) throws -> Data {
		let dictionary = serializedDictionary.serialize()
		return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
	}
}
