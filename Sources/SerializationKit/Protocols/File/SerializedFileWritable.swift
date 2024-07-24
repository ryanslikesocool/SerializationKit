import Foundation

/// An object that can be written to a file.
public protocol SerializedFileWritable<WritingOptions> {
	associatedtype WritingOptions

	/// Write the object to a file.
	/// - Parameters:
	///   - url: The destination for the written file.
	///   - options: Options used when writing the file.
	func write(to url: URL, options: WritingOptions) throws
}

// MARK: - Default Implementation

public extension SerializedFileWritable<FileWrapper.WritingOptions> where Self: FileWrapperWritable {
	func write(to url: URL, options: WritingOptions = []) throws {
		try url.createIntermediateDirectories()

		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: url.path) {
			try fileManager.removeItem(at: url)
		}

		let fileWrapper = try fileWrapper()
		try fileWrapper.write(to: url, options: options, originalContentsURL: nil)
	}
}

public extension SerializedFileWritable<Data.WritingOptions> where Self: SerializedDataWritable {
	func write(to url: URL, options: WritingOptions = []) throws {
		try url.createIntermediateDirectories()

		let fileManager = FileManager.default
		if !fileManager.fileExists(atPath: url.path) {
			fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
		}

		let data = try toData()
		try data.write(to: url, options: options)
	}
}
