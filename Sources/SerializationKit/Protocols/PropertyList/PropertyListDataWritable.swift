import Foundation

public protocol PropertyListDataWritable: SerializedDataWritable {
	static var propertyListFormat: PropertyListSerialization.PropertyListFormat { get }

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data
}

public extension PropertyListDataWritable {
	static var propertyListFormat: PropertyListSerialization.PropertyListFormat { .xml }
	static var plistFormat: PropertyListSerialization.PropertyListFormat { propertyListFormat }
}
