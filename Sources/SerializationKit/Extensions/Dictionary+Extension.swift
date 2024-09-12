import Foundation

public extension Dictionary where Key == UUID, Value: Decodable {
	/// Convenience type for serialization that maps dictionary keys from `UUID` to `String`.
	///
	/// `UUID`s are commonly used as keys for dictionaries, but Swift does not convert them into a `String` representation when serializing, causing issues.
	static var uuidKeyCodingType: [String: Value].Type { [String: Value].self }
}

public extension Dictionary where Key == String, Value: Decodable {
	/// Convenience value for serialization that maps dictionary keys from `String` to `UUID`.
	///
	/// `UUID`s are commonly used as keys for dictionaries, but Swift does not convert them into a `String` representation when serializing, causing issues.
	var uuidKeyDecodedValue: [UUID: Value] {
		reduce(into: [UUID: Value]()) { result, element in
			guard let key = UUID(uuidString: element.key) else {
				return
			}
			result[key] = element.value
		}
	}
}

public extension Dictionary where Key == UUID, Value: Encodable {
	/// Convenience value for serialization that maps dictionary keys from `UUID` to `String`.
	///
	/// `UUID`s are commonly used as keys for dictionaries, but Swift does not convert them into a `String` representation when serializing, causing issues.
	var uuidKeyEncodingValue: [String: Value] {
		reduce(into: [String: Value]()) { result, element in
			result[element.key.uuidString] = element.value
		}
	}
}
