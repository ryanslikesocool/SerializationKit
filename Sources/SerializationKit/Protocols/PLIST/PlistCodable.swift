import Foundation

// MARK: - PlistDecodable

public protocol PlistDecodable: Decodable, SerializedDataReadable { }

// MARK: - PlistEncodable

public protocol PlistEncodable: Encodable, PlistDataWritable { }

// MARK: - Typealias

public typealias PlistCodable = PlistDecodable & PlistEncodable

// MARK: - Default Implementation

public extension PlistDecodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder()
		self = try decoder.decode(Self.self, from: data)
	}
}

public extension PlistEncodable {
	func toData() throws -> Data {
		try toData(outputFormat: Self.plistFormat)
	}

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = outputFormat
		return try encoder.encode(self)
	}
}
