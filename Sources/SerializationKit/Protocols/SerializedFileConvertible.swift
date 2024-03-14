import Foundation

// MARK: - SerializedFileReadable

public protocol SerializedFileReadable: SerializedDataReadable {
	init(url: URL) throws
}

// MARK: - SerializedFileWritable

public protocol SerializedFileWritable: SerializedDataWritable {
	func save(to url: URL) throws
}

// MARK: - Typealias

public typealias SerializedFileConvertible = SerializedFileReadable & SerializedFileWritable

// MARK: - Default Implementation

public extension SerializedFileReadable where Self: FileWrapperReadable {
	init(url: URL) throws {
		let fileWrapper = try FileWrapper(url: url)
		try self.init(fileWrapper: fileWrapper)
	}
}

public extension SerializedFileWritable where Self: FileWrapperWritable {
	func save(to url: URL) throws {
		try url.createIntermediateDirectories()
		
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: url.path) {
			try fileManager.removeItem(at: url)
		}
		
		let fileWrapper = try fileWrapper()
		try fileWrapper.write(to: url, originalContentsURL: nil)
	}
}

public extension SerializedFileReadable {
	init(url: URL) throws {
		let data = try Data(contentsOf: url)
		try self.init(data: data)
	}
}

public extension SerializedFileWritable {
	func save(to url: URL) throws {
		try url.createIntermediateDirectories()

		let fileManager = FileManager.default
		if !fileManager.fileExists(atPath: url.path) {
			fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
		}

		let data = try toData()
		try data.write(to: url)
	}
}
