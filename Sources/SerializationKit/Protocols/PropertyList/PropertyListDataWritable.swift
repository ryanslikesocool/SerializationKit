import Foundation

public protocol PropertyListDataWritable: SerializedDataWritable {
	typealias PropertyListFormat = PropertyListSerialization.PropertyListFormat

	static var propertyListFormat: PropertyListFormat { get }

	func toData(outputFormat: PropertyListFormat) throws -> Data
}

// MARK: - Default Implementation

public extension PropertyListDataWritable {
	static var propertyListFormat: PropertyListFormat { .xml }
	static var plistFormat: PropertyListFormat { propertyListFormat }
}
