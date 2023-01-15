import Foundation
import SwiftUI

public extension FileDocument where Self: SerializedDataConvertible {
	init(configuration: ReadConfiguration) throws {
		guard
			let data = configuration.file.regularFileContents
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self = try Self(data: data)
	}

	func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
		let data = try toData()
		return FileWrapper(regularFileWithContents: data)
	}
}
