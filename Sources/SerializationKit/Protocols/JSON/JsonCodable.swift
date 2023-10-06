import Foundation

// MARK: - JsonReadable

public protocol JsonDecodable: Decodable, SerializedDataReadable { }

// MARK: - JsonWritable

public protocol JsonEncodable: Encodable, JsonDataWritable { }

// MARK: - Typealias

public typealias JsonCodable = JsonDecodable & JsonEncodable

// MARK: - Default Implementation

public extension JsonDecodable {
	init(data: Data) throws {
		let decoder = JSONDecoder()
		self = try decoder.decode(Self.self, from: data)
	}
}

public extension JsonEncodable {
	func toData() throws -> Data {
		try toData(outputFormatting: Self.outputFormatting)
	}

	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = outputFormatting
		return try encoder.encode(self)
	}
}
