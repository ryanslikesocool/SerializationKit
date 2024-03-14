import Foundation

public extension URL {
	/// Create any required intermediate directories in this URL's path.
	func createIntermediateDirectories() throws {
		let fileManager = FileManager.default
		let folder = deletingLastPathComponent()
		if !fileManager.fileExists(atPath: folder.path) {
			try fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
		}
	}
}
