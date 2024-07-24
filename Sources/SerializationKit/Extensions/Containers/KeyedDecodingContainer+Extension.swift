import Foundation

public extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
		try decode(T.self, forKey: key)
	}

	func decodeIfPresent<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T? {
		try decodeIfPresent(T.self, forKey: key)
	}

	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: KeyedDecodingContainer<K>.Key) throws -> U {
		guard let value = try decode(CodablePayload<T>.self, forKey: key).payload as? U else {
			throw DecodingError.typeMismatch(U.self, .init(codingPath: [key], debugDescription: ""))
		}
		return value
	}

	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: KeyedDecodingContainer<K>.Key) throws -> [U] {
		try decode([CodablePayload<T>].self, forKey: key).compactMap { $0.payload as? U }
	}

	func decodeIfPresent<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: KeyedDecodingContainer<K>.Key) throws -> U? {
		try decodeIfPresent(CodablePayload<T>.self, forKey: key)?.payload as? U
	}

	func decodeIfPresent<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: KeyedDecodingContainer<K>.Key) throws -> [U]? {
		try decodeIfPresent([CodablePayload<T>].self, forKey: key)?.compactMap { $0.payload as? U }
	}
}
