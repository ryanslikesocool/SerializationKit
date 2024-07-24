import Foundation

public extension KeyedEncodingContainer {
	mutating func encode<T: CodableMetatypeAccessor, U: Codable>(_ value: U, using metatype: T.Type, forKey key: KeyedEncodingContainer<K>.Key) throws {
		let valueType = type(of: value)
		guard let base = T.allCases.first(where: { metatype in metatype.encodableMetatype == valueType }) else {
			print("Failed to find a valid metatype in \(T.self) for the given value \(value)")
			return
		}
		try encode(CodablePayload<T>(value, base: base), forKey: key)
	}

	mutating func encode<T: CodableMetatypeAccessor>(_ values: [any Codable], using metatype: T.Type, forKey key: KeyedEncodingContainer<K>.Key) throws {
		try encode(values.compactMap { value -> CodablePayload<T>? in
			let valueType = type(of: value)
			guard let base = T.allCases.first(where: { metatype in metatype.encodableMetatype == valueType }) else {
				print("Failed to find a valid metatype in \(T.self) for the given value \(value)")
				return nil
			}
			return CodablePayload(value, base: base)
		}, forKey: key)
	}

	mutating func encodeIfPresent<T: CodableMetatypeAccessor, U: Codable>(_ value: U?, using metatype: T.Type, forKey key: KeyedEncodingContainer<K>.Key) throws {
		guard let value else {
			return
		}
		try encode(value, using: metatype, forKey: key)
	}

	mutating func encodeIfPresent<T: CodableMetatypeAccessor>(_ values: [any Codable]?, using metatype: T.Type, forKey key: KeyedEncodingContainer<K>.Key) throws {
		guard let values else {
			return
		}
		try encode(values, using: metatype, forKey: key)
	}

//	mutating func encode(_ values: [any Encodable], forKey key: KeyedEncodingContainer<K>.Key) throws {
//		var container = nestedUnkeyedContainer(forKey: key)
//		for value in values {
//			try container.encode(value)
//		}
//	}
}
