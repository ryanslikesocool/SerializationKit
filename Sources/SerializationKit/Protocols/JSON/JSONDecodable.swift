import Foundation

/// An object that can be decoded from JSON data.
public protocol JSONDecodable: Decodable, SerializedDataReadable { }

// MARK: - Default Implementation

public extension JSONDecodable {
	init(data: Data) throws {
		self = try JSONDecoder.shared
			.decode(Self.self, from: data)
	}
}
