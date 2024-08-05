import Foundation

/// An object that can encoded to JSON data.
public protocol JSONEncodable: Encodable, JSONDataWritable { }

// MARK: - Default Implementation

public extension JSONEncodable {
	func toData(outputFormatting: OutputFormatting) throws -> Data {
		try JSONEncoder.shared
			.with(outputFormatting: outputFormatting)
			.encode(self)
	}
}
