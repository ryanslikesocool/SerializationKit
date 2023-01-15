import Foundation

/// The base protocol for an object that can be serialized into a ``Data`` object.
public protocol SerializedDataConvertible {
	init(data: Data) throws
	func toData() throws -> Data
}
