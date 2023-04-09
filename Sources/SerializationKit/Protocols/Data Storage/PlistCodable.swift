import Foundation

public protocol PlistCodable: Codable, PlistDataConvertible { }

public extension PlistCodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder()
		self = try decoder.decode(Self.self, from: data)
	}

	func toData() throws -> Data {
		try toData(outputFormat: Self.plistFormat)
	}

	func toData(outputFormat: PropertyListSerialization.PropertyListFormat) throws -> Data {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = outputFormat
		return try encoder.encode(self)
	}
}
