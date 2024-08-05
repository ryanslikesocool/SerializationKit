import Foundation

/// An object that can be read from ``Foundation/Data``.
public protocol SerializedDataReadable {
	/// Read the object from data.
	init(data: Data) throws
}
