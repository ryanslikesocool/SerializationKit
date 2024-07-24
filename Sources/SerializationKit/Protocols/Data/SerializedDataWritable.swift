import Foundation

/// An object that can be written to ``Foundation/Data``.
public protocol SerializedDataWritable {
	/// Write the object to data.
	func toData() throws -> Data
}
