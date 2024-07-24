import Foundation

/// An object that can be written to JSON data.
public protocol JSONDataWritable: SerializedDataWritable {
	typealias OutputFormatting = JSONEncoder.OutputFormatting

	/// The default output JSON formatting.
	static var outputFormatting: OutputFormatting { get }

	/// Write the object to JSON data using the provided formatting.
	/// - Parameter outputFormatting: The JSON formatting to use.
	func toData(outputFormatting: OutputFormatting) throws -> Data
}

// MARK: - Default Implementation

public extension JSONDataWritable {
	static var outputFormatting: OutputFormatting { [] }

	func toData() throws -> Data {
		try toData(outputFormatting: Self.outputFormatting)
	}
}
