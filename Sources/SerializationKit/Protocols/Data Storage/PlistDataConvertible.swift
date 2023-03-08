import Foundation

public protocol PlistDataConvertible: SerializedDataConvertible {
	static var format: PropertyListSerialization.PropertyListFormat { get }

	func toData(format: PropertyListSerialization.PropertyListFormat) throws -> Data
}
