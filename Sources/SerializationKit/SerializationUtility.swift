import Foundation

public enum SerializationUtility {
	public static func toPlistData(_ serializedDictionary: any SerializedDictionaryConvertible, format: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let dictionary = serializedDictionary.serialize()
		return try PropertyListSerialization.data(fromPropertyList: dictionary, format: format, options: 0)
	}

	public static func toJsonData(_ serializedDictionary: any SerializedDictionaryConvertible) throws -> Data {
		let dictionary = serializedDictionary.serialize()
		return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
	}

	public static func attemptSerialization(_ object: Any) -> Any {
		switch object {
			case let obj as any Serializable:
				return obj.serialize()
			case let array as [Any]:
				return array.map { attemptSerialization($0) }
			case let dictionary as [String: Any]:
				return dictionary.reduce(into: [String: Any]()) { result, element in
					result[element.key] = attemptSerialization(element.value)
				}
			default:
				print("Serialization failed on \(type(of: object)): \(object)")
				return object
		}
	}
}
