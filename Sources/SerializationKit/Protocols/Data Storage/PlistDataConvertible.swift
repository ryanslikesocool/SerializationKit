import Foundation

public protocol PlistDataConvertible: SerializedDataConvertible {
	static var plistFormat: PropertyListSerialization.PropertyListFormat { get }

	func toData(format: PropertyListSerialization.PropertyListFormat) throws -> Data
}
