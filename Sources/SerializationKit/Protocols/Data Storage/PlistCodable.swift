import Foundation

public protocol PlistCodable: Codable, PlistDataConvertible { }

public extension PlistCodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder()
		self = try decoder.decode(Self.self, from: data)
	}

	func toData() throws -> Data {
		try toData(format: Self.format)
	}

	func toData(format: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = format
		return try encoder.encode(self)
	}
}
