import Foundation

// MARK: - PlistDecodable

public protocol PropertyListDecodable: Decodable, SerializedDataReadable { }

// MARK: - PlistEncodable

public protocol PropertyListEncodable: Encodable, PlistDataWritable { }

// MARK: - Typealias

public typealias PropertyListCodable = PlistDecodable & PlistEncodable

// MARK: - Default Implementation

public extension PropertyListDecodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder()
		self = try decoder.decode(Self.self, from: data)
	}
}

public extension PropertyListEncodable {
	func toData() throws -> Data {
		try toData(outputFormat: Self.propertyListFormat)
	}

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = outputFormat
		return try encoder.encode(self)
	}
}
