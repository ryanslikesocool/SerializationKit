import Foundation

public extension KeyedDecodingContainer {
	func decode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
		try self.decode(T.self, forKey: key)
	}
}
