import Foundation

/// An object that can be written to Property List data.
public protocol PropertyListDataWritable: SerializedDataWritable {
	typealias PropertyListFormat = PropertyListSerialization.PropertyListFormat

	/// The default output Property List format.
	static var propertyListFormat: PropertyListFormat { get }

	/// Write the object to Property List data using the provided format.
	/// - Parameter outputFormat: The Property List format to use.
	func toData(outputFormat: PropertyListFormat) throws -> Data
}

// MARK: - Default Implementation

public extension PropertyListDataWritable {
	static var propertyListFormat: PropertyListFormat { .xml }
	static var plistFormat: PropertyListFormat { propertyListFormat }

	func toData() throws -> Data {
		try toData(outputFormat: Self.propertyListFormat)
	}
}
