import Foundation

public extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: Key) throws -> T {
		try decode(T.self, forKey: key)
	}

	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: Key) throws -> U {
		guard let value = try decode(CodablePayload<T>.self, forKey: key).payload as? U else {
			let context = DecodingError.Context(codingPath: [key], debugDescription: "")
			throw DecodingError.typeMismatch(U.self, context)
		}
		return value
	}

	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: Key) throws -> [U] {
		try decode([CodablePayload<T>].self, forKey: key).compactMap { $0.payload as? U }
	}
}

// MARK: - If Present

public extension KeyedDecodingContainer {
	func decodeIfPresent<T: Decodable>(forKey key: Key) throws -> T? {
		try decodeIfPresent(T.self, forKey: key)
	}

	func decodeIfPresent<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: Key) throws -> U? {
		try decodeIfPresent(CodablePayload<T>.self, forKey: key)?.payload as? U
	}

	func decodeIfPresent<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: Key) throws -> [U]? {
		try decodeIfPresent([CodablePayload<T>].self, forKey: key)?.compactMap { $0.payload as? U }
	}
}
