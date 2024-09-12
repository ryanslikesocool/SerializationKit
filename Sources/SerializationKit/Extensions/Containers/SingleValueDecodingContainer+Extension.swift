import Foundation

public extension SingleValueDecodingContainer {
	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self) throws -> U! {
		try decode(CodablePayload<T>.self).payload as? U
	}

	func decode<T: Decodable>(_ type: T.Type = T.self) throws -> T {
		try decode(type)
	}
}
