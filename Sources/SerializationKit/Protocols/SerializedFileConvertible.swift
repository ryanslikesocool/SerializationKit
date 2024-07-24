import Foundation

// MARK: - SerializedFileReadable

public protocol SerializedFileReadable<ReadingOptions> {
	associatedtype ReadingOptions

	init(contentsOf url: URL, options: ReadingOptions) throws
}

// MARK: - SerializedFileWritable

public protocol SerializedFileWritable<WritingOptions> {
	associatedtype WritingOptions

	func write(to url: URL, options: WritingOptions) throws
}

// MARK: - Typealias

public typealias SerializedFileConvertible<ReadingOptions, WritingOptions> = SerializedFileReadable<ReadingOptions> & SerializedFileWritable<WritingOptions>
public typealias SerializedDataFileConvertible = SerializedFileConvertible<Data.ReadingOptions, Data.WritingOptions>

// MARK: - Default Implementation

public extension SerializedFileReadable<FileWrapper.ReadingOptions> where Self: FileWrapperReadable {
	init(contentsOf url: URL, options: ReadingOptions = []) throws {
		let fileWrapper = try FileWrapper(url: url, options: options)
		try self.init(fileWrapper: fileWrapper)
	}
}

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

public extension SerializedFileReadable<Data.ReadingOptions> where Self: SerializedDataReadable {
	init(contentsOf url: URL, options: ReadingOptions = []) throws {
		let data: Data = try Data(contentsOf: url, options: options)
		try self.init(data: data)
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
