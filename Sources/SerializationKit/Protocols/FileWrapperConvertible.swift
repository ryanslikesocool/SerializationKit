import Foundation

// MARK: - FileWrapperReadable

public protocol FileWrapperReadable {
	init(fileWrapper: FileWrapper) throws
}

// MARK: - FileWrapperWritable

public protocol FileWrapperWritable {
	func fileWrapper() throws -> FileWrapper
}

// MARK: - Typealias

public typealias FileWrapperConvertible = FileWrapperReadable & FileWrapperWritable

// MARK: - Default Implementation

public extension FileWrapperReadable where Self: SerializedDataReadable {
	init(fileWrapper: FileWrapper) throws {
		guard let data = fileWrapper.regularFileContents else {
			throw CocoaError(.fileReadUnknown)
		}
		try self.init(data: data)
	}
}

public extension FileWrapperWritable where Self: SerializedDataWritable {
	func fileWrapper() throws -> FileWrapper {
		let data = try toData()
		return FileWrapper(regularFileWithContents: data)
	}
}
