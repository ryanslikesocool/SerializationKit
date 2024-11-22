import Foundation

/// An object that can be read from a file.
public protocol SerializedFileReadable<ReadingOptions> {
	associatedtype ReadingOptions

	/// Read the object from a file.
	/// - Parameters:
	///   - url: The source of the file to read.
	///   - options: Options used to read the file.
	init(contentsOf url: URL, options: ReadingOptions) throws
}

// MARK: - Default Implementation

public extension SerializedFileReadable where
	Self: FileWrapperReadable,
	ReadingOptions == FileWrapper.ReadingOptions
{
	init(contentsOf url: URL, options: ReadingOptions = []) throws {
		let fileWrapper = try FileWrapper(url: url, options: options)
		try self.init(contentsOf: fileWrapper)
	}
}

public extension SerializedFileReadable where
	Self: SerializedDataReadable,
	ReadingOptions == Data.ReadingOptions
{
	init(contentsOf url: URL, options: ReadingOptions = []) throws {
		let data: Data = try Data(contentsOf: url, options: options)
		try self.init(data: data)
	}
}

/// An object that can be read from a file as ``Foundation/Data``.
public typealias SerializedDataFileReadable = SerializedFileReadable<Data.ReadingOptions>
