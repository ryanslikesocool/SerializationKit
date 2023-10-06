import Foundation

// MARK: - SerializedDataReadable

public protocol SerializedDataReadable {
	init(data: Data) throws
}

// MARK: - SerializedDataWritable

public protocol SerializedDataWritable {
	func toData() throws -> Data
}

// MARK: - Typealias

public typealias SerializedDataConvertible = SerializedDataReadable & SerializedDataWritable
