import Foundation

public protocol JsonCodable: Codable, JsonDataConvertible { }

public extension JsonCodable {
	init(data: Data) throws {
		let decoder = JSONDecoder()
		self = try decoder.decode(Self.self, from: data)
	}

	func toData() throws -> Data {
		try toData(outputFormatting: Self.outputFormatting)
	}

	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = outputFormatting
		return try encoder.encode(self)
	}
}
