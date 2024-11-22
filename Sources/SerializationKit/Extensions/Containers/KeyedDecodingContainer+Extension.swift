import Foundation

public extension KeyedDecodingContainer {
	func decode<T>(forKey key: Key) throws -> T where
		T: Decodable
	{
		try decode(T.self, forKey: key)
	}

	func decode<T, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: Key) throws -> U where
		T: CodableMetatypeAccessor
	{
		guard let value = try decode(CodablePayload<T>.self, forKey: key).payload as? U else {
			let context = DecodingError.Context(codingPath: [key], debugDescription: "")
			throw DecodingError.typeMismatch(U.self, context)
		}
		return value
	}

	func decode<T, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: Key) throws -> [U] where
		T: CodableMetatypeAccessor
	{
		try decode([CodablePayload<T>].self, forKey: key).compactMap { $0.payload as? U }
	}
}

// MARK: - If Present

public extension KeyedDecodingContainer {
	func decodeIfPresent<T>(forKey key: Key) throws -> T? where
		T: Decodable
	{
		try decodeIfPresent(T.self, forKey: key)
	}

	func decodeIfPresent<T, U>(using metatype: T.Type, as concreteType: U.Type = U.self, forKey key: Key) throws -> U? where
		T: CodableMetatypeAccessor
	{
		try decodeIfPresent(CodablePayload<T>.self, forKey: key)?.payload as? U
	}

	func decodeIfPresent<T, U>(using metatype: T.Type, as concreteType: [U].Type = [U].self, forKey key: Key) throws -> [U]? where
		T: CodableMetatypeAccessor
	{
		try decodeIfPresent([CodablePayload<T>].self, forKey: key)?.compactMap { $0.payload as? U }
	}
}
