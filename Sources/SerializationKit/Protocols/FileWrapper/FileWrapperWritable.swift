import Foundation

/// An object that supports writing to a ``Foundation/FileWrapper``.
public protocol FileWrapperWritable {
	/// Write the object to a file wrapper.
	func fileWrapper() throws -> FileWrapper
}

// MARK: - Default Implementation

public extension FileWrapperWritable where Self: SerializedDataWritable {
	func fileWrapper() throws -> FileWrapper {
		let data = try toData()
		return FileWrapper(regularFileWithContents: data)
	}
}
