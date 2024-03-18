public protocol OrderedDirectoryFileWrapperContent: FileWrapperConvertible, Identifiable where ID: Codable {
	/// The extension of the file.  This should exclude the leading period.
	static var fileExtension: String { get }

	/// The file name, excluding the extension.
	var fileName: String { get }
}

// MARK: - Default Implementation

public extension OrderedDirectoryFileWrapperContent where ID: CustomStringConvertible {
	var fileName: String { id.description }
}
