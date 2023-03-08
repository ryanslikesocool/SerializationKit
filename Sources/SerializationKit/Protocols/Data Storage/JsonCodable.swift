import Foundation

public protocol JsonCodable: Codable, JsonDataConvertible { }

public extension JsonCodable {
	init(data: Data) throws {
		let decoder = JSONDecoder()
		self = try decoder.decode(Self.self, from: data)
	}

	func toData() throws -> Data {
		let encoder = JSONEncoder()
		return try encoder.encode(self)
	}
}
