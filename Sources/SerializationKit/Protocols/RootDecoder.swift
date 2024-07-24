import Foundation

public protocol RootDecoder {
	func decode<T: Decodable>(
		_ type: T.Type,
		from data: Data
	) throws -> T

	func decode<T: Decodable>(
		_ type: T.Type,
		from url: URL,
		options: Data.ReadingOptions
	) throws -> T
}

// MARK: - Default Implementation

public extension RootDecoder {
	func decode<T: Decodable>(
		_ type: T.Type = T.self,
		from url: URL,
		options: Data.ReadingOptions = []
	) throws -> T {
		let data: Data = try Data(contentsOf: url, options: options)
		return try decode(type, from: data)
	}
}
