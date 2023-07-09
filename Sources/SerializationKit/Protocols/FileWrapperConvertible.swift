import Foundation

public protocol FileWrapperConvertible {
	init(fileWrapper: FileWrapper) throws

	func fileWrapper() throws -> FileWrapper
}

public extension FileWrapperConvertible where Self: SerializedDataConvertible {
	init(fileWrapper: FileWrapper) throws {
		guard let data = fileWrapper.regularFileContents else {
			throw CocoaError(.fileReadUnknown)
		}
		try self.init(data: data)
	}

	func fileWrapper() throws -> FileWrapper {
		let data = try toData()
		return FileWrapper(regularFileWithContents: data)
	}
}
