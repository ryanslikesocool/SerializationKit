import Foundation

// MARK: - JSONDecodable

public protocol JSONDecodable: Decodable, SerializedDataReadable { }

// MARK: - JSONEncodable

public protocol JSONEncodable: Encodable, JSONDataWritable { }

// MARK: - Typealias

public typealias JSONCodable = JSONDecodable & JSONEncodable

// MARK: - Default Implementation

public extension JSONDecodable {
	init(data: Data) throws {
		self = try JSONDecoder.shared
			.decode(Self.self, from: data)
	}
}

public extension JSONEncodable {
	func toData() throws -> Data {
		try toData(outputFormatting: Self.outputFormatting)
	}

	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data {
		try JSONEncoder.shared
			.with(outputFormatting: outputFormatting)
			.encode(self)
	}
}
