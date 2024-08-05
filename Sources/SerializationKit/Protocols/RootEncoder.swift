import Foundation

/// A root encoder object.
public protocol RootEncoder {
	typealias WritingOptions = Data.WritingOptions

	func encode<T: Encodable>(
		_ value: T
	) throws -> Data

	func encode<T: Encodable>(
		_ value: T,
		to url: URL,
		options: WritingOptions
	) throws
}

// MARK: - Default Implementation

public extension RootEncoder {
	func encode<T: Encodable>(
		_ value: T,
		to url: URL,
		options: WritingOptions = []
	) throws {
		let data: Data = try encode(value)
		try data.write(to: url, options: options)
	}
}
