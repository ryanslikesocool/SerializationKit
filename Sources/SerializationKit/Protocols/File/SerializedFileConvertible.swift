import struct Foundation.Data

/// An object that can be read from and written to a file.
public typealias SerializedFileConvertible<ReadingOptions, WritingOptions> = SerializedFileReadable<ReadingOptions> & SerializedFileWritable<WritingOptions>

/// An object that can be read from and written to a file as ``Foundation/Data``.
public protocol SerializedDataFileConvertible: SerializedFileReadable, SerializedFileWritable where
	ReadingOptions == Data.ReadingOptions,
	WritingOptions == Data.WritingOptions
{
	// NOTE: this protocol would ideally be declared as a typealias, but Swift doesn't like that due to the explicitly specialized generic arguments
	// public typealias SerializedDataFileConvertible = SerializedFileConvertible<Data.ReadingOptions, Data.WritingOptions>
}
