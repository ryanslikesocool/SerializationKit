import Foundation

public protocol PlistDataWritable: SerializedDataWritable {
	static var plistFormat: PropertyListSerialization.PropertyListFormat { get }

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data
}

public extension PlistDataWritable {
	static var plistFormat: PropertyListSerialization.PropertyListFormat { .xml }
}
