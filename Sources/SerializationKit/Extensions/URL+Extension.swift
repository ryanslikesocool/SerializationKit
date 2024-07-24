import Foundation

public extension URL {
	/// Create any required intermediate directories in this URL's path.
	func createIntermediateDirectories() throws {
		let fileManager = FileManager.default

		let directory: URL = if hasDirectoryPath {
			self
		} else {
			deletingLastPathComponent()
		}

		if !fileManager.fileExists(atPath: directory.path) {
			try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		}
	}

	var isDirectory: Bool {
		get throws {
			try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
		}
	}
}
