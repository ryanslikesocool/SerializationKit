import Foundation

public struct Serialization {
    private init() { }
}

public extension Serialization {
	static func toPlistData(_ serializedDictionary: any SerializedDictionaryConvertible, format: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let dictionary = serializedDictionary.toDictionary()
		return try PropertyListSerialization.data(fromPropertyList: dictionary, format: format, options: 0)
	}

	static func toJsonData(_ serializedDictionary: any SerializedDictionaryConvertible) throws -> Data {
		let dictionary = serializedDictionary.toDictionary()
		return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
	}
}
