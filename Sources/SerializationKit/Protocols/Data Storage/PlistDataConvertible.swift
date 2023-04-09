import Foundation

public protocol PlistDataConvertible: SerializedDataConvertible {
	static var plistFormat: PropertyListSerialization.PropertyListFormat { get }

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data
}

public extension PlistDataConvertible {
	static var plistFormat: PropertyListSerialization.PropertyListFormat { .xml }
}
