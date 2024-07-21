import Foundation

// MARK: - PlistDecodable

public protocol PropertyListDecodable: Decodable, SerializedDataReadable { }

// MARK: - PlistEncodable

public protocol PropertyListEncodable: Encodable, PropertyListDataWritable {
	typealias PropertyListFormat = PropertyListSerialization.PropertyListFormat
}

// MARK: - Typealias

public typealias PropertyListCodable = PropertyListDecodable & PropertyListEncodable

// MARK: - Default Implementation

public extension PropertyListDecodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder.shared
		self = try decoder.decode(Self.self, from: data)
	}
}

public extension PropertyListEncodable {
	func toData() throws -> Data {
		try toData(outputFormat: Self.propertyListFormat)
	}

	func toData(outputFormat: PropertyListFormat) throws -> Data {
		try PropertyListEncoder.shared
			.with(outputFormat: outputFormat)
			.encode(self)
	}
}
