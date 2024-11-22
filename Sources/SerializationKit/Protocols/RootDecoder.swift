import Foundation

/// A root decoder object.
public protocol RootDecoder {
	func decode<T>(
		_ type: T.Type,
		from data: Data
	) throws -> T where
		T: Decodable

	func decode<T>(
		_ type: T.Type,
		from url: URL,
		options: Data.ReadingOptions
	) throws -> T where
		T: Decodable
}

// MARK: - Default Implementation

public extension RootDecoder {
	func decode<T>(
		_ type: T.Type = T.self,
		from url: URL,
		options: Data.ReadingOptions = []
	) throws -> T where
		T: Decodable
	{
		let data: Data = try Data(contentsOf: url, options: options)
		return try decode(type, from: data)
	}
}
