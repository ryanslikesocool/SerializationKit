import Foundation

/// An object that supports reading from a ``Foundation/FileWrapper``.
public protocol FileWrapperReadable {
	/// Read the object from a file wrapper.
	init(contentsOf fileWrapper: FileWrapper) throws
}

// MARK: - Default Implementation

public extension FileWrapperReadable where Self: SerializedDataReadable {
	init(contentsOf fileWrapper: FileWrapper) throws {
		guard let data = fileWrapper.regularFileContents else {
			throw CocoaError(.fileReadUnknown)
		}
		try self.init(data: data)
	}
}
