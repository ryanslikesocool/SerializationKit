import Foundation

public extension SingleValueDecodingContainer {
	func decode<T: CodableMetatypeAccessor, U>(using metatype: T.Type, as concreteType: U.Type = U.self) throws -> U! {
		try decode(CodablePayload<T>.self).payload as? U
	}
}
