import Foundation

// MARK: - SerializedFileReadable

public protocol SerializedFileReadable: SerializedDataReadable {
	init?(url: URL)
}

// MARK: - SerializedFileWritable

public protocol SerializedFileWritable: SerializedDataWritable {
	func save(to url: URL)
}

// MARK: - Typealias

public typealias SerializedFileConvertible = SerializedFileReadable & SerializedFileWritable

// MARK: - Default Implementation

public extension SerializedFileReadable {
	init?(url: URL) {
		do {
			let data = try Data(contentsOf: url)
			try self.init(data: data)
		} catch {
			return nil
		}
	}
}

public extension SerializedFileWritable {
	func save(to url: URL) {
		let fileManager = FileManager.default

		do {
			let folder = url.deletingLastPathComponent()
			if !fileManager.fileExists(atPath: folder.path) {
				try fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
			}

			if !fileManager.fileExists(atPath: url.path) {
				fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
			}

			let data = try toData()
			try data.write(to: url)
		} catch {
			print("Couldn't save file to \(url)", error)
		}
	}
}
