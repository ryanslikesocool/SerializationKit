import Foundation

/// The base protocol for an object that can be serialized into a stored file.
public protocol SerializedFileConvertible: SerializedDataConvertible {
	init?(url: URL)
	func save(to url: URL)
}

public extension SerializedFileConvertible {
	init?(url: URL) {
		do {
			let data = try Data(contentsOf: url)
			try self.init(data: data)
		} catch {
			return nil
		}
	}

	func save(to url: URL) {
		let fileManager = FileManager.default

		do {
			var isDirectory: ObjCBool = true
			let folder = url.deletingLastPathComponent()
			if !fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) {
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
