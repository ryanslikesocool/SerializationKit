import Foundation

/// A root encoder object.
public protocol RootEncoder {
	typealias WritingOptions = Data.WritingOptions

	func encode<T>(
		_ value: T
	) throws -> Data where
		T: Encodable

	func encode<T>(
		_ value: T,
		to url: URL,
		options: WritingOptions
	) throws where
		T: Encodable
}

// MARK: - Default Implementation

public extension RootEncoder {
	func encode<T>(
		_ value: T,
		to url: URL,
		options: WritingOptions = []
	) throws where
		T: Encodable
	{
		let data: Data = try encode(value)
		try data.write(to: url, options: options)
	}
}
