import Foundation

/// An object useful for encoding and decoding a directory of objects with a specific order.
public struct OrderedDirectoryFileWrapper<Element: OrderedDirectoryFileWrapperContent> {
	typealias FileMap = SerializationKit.FileMap<Element.ID>

	public let elements: [Element]

	public init(elements: some Sequence<Element>) {
		self.elements = Array(elements)
	}
}

// MARK: - FileWrapperConvertible

extension OrderedDirectoryFileWrapper: FileWrapperConvertible {
	public init(fileWrapper: FileWrapper) throws {
		guard let fileWrappers = fileWrapper.fileWrappers else {
			throw CocoaError(.fileReadUnknown)
		}

		var elements = try fileWrappers
			.filter { $0.key.hasSuffix(Element.fileExtension) }
			.map { try Element(fileWrapper: $0.value) }

		if
			let fileMapFileWrapper = fileWrappers[FileMap.fileName],
			let fileMap = try? FileMap(fileWrapper: fileMapFileWrapper)
		{
			elements = fileMap.sort(elements)
		}

		self.elements = elements
	}

	public func fileWrapper() throws -> FileWrapper {
		var fileWrappers: [String: FileWrapper] = try [
			FileMap.fileName: FileMap(elements: elements).fileWrapper(),
		]
		for element in elements {
			fileWrappers[Self.formatFileName(element)] = try element.fileWrapper()
		}

		return FileWrapper(directoryWithFileWrappers: fileWrappers)
	}
}

// MARK: -

private extension OrderedDirectoryFileWrapper {
	static func formatFileName(_ element: Element) -> String {
		"\(element.fileName).\(Element.fileExtension)"
	}
}
