import Foundation
import SwiftUI

public extension FileDocument where Self: SerializedDataReadable {
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self = try Self(data: data)
	}
}

public extension FileDocument where Self: SerializedDataWritable {
	func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
		let data = try toData()
		return FileWrapper(regularFileWithContents: data)
	}
}

public extension FileDocument where Self: FileWrapperReadable {
	init(configuration: ReadConfiguration) throws {
		try self.init(fileWrapper: configuration.file)
	}
}

public extension FileDocument where Self: FileWrapperWritable {
	func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
		try fileWrapper()
	}
}
