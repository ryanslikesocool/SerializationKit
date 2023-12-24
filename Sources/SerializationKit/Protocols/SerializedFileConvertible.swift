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

public extension SerializedFileReadable {
	init(url: URL) throws {
		let data = try Data(contentsOf: url)
		try self.init(data: data)
	}
}

public extension SerializedFileWritable {
	func save(to url: URL) throws {
		let fileManager = FileManager.default
		let folder = url.deletingLastPathComponent()
		if !fileManager.fileExists(atPath: folder.path) {
			try fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
		}

		if !fileManager.fileExists(atPath: url.path) {
			fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
		}

		let data = try toData()
		try data.write(to: url)
	}
}
