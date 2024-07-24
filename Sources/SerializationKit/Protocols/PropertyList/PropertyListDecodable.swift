import Foundation

/// An object that can be decoded from Property List data.
public protocol PropertyListDecodable: Decodable, SerializedDataReadable { }

// MARK: - Default Implementation

public extension PropertyListDecodable {
	init(data: Data) throws {
		let decoder = PropertyListDecoder.shared
		self = try decoder.decode(Self.self, from: data)
	}
}
