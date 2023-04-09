import Foundation

public extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
		try decode(T.self, forKey: key)
	}
}
