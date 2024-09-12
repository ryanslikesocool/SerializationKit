import Foundation

package extension URL {
	/// Attempt to create any required intermediate directories in this URL's path.
	func createIntermediateDirectories() throws {
		let fileManager = FileManager.default

		let directory: URL = if hasDirectoryPath {
			self
		} else {
			deletingLastPathComponent()
		}

		try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
	}

	var isDirectory: Bool {
		get throws {
			try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
		}
	}
}
