import Foundation

/// An object that can be read from and written to a file.
public typealias SerializedFileConvertible<ReadingOptions, WritingOptions> = SerializedFileReadable<ReadingOptions> & SerializedFileWritable<WritingOptions>

/// An object that can be read from and written to a file as ``Foundation/Data``.
public typealias SerializedDataFileConvertible = SerializedFileConvertible<Data.ReadingOptions, Data.WritingOptions>
