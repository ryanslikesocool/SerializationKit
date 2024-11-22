import Foundation

public extension SingleValueDecodingContainer {
	func decode<T, U>(using metatype: T.Type, as concreteType: U.Type = U.self) throws -> U! where
		T: CodableMetatypeAccessor
	{
		try decode(CodablePayload<T>.self).payload as? U
	}

	func decode<T>(_ type: T.Type = T.self) throws -> T where
		T: Decodable
	{
		try decode(type)
	}
}
