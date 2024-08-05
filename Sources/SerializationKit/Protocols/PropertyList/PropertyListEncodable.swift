import Foundation

/// An object that can be encoded to Property List data.
public protocol PropertyListEncodable: Encodable, PropertyListDataWritable {
	typealias PropertyListFormat = PropertyListSerialization.PropertyListFormat
}

// MARK: - Default Implementation

public extension PropertyListEncodable {
	func toData(outputFormat: PropertyListFormat) throws -> Data {
		try PropertyListEncoder.shared
			.with(outputFormat: outputFormat)
			.encode(self)
	}
}
