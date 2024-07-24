import Foundation

public protocol JSONDataWritable: SerializedDataWritable {
	typealias OutputFormatting = JSONEncoder.OutputFormatting

	static var outputFormatting: OutputFormatting { get }
	
	func toData(outputFormatting: OutputFormatting) throws -> Data
}

// MARK: - Default Implementation

public extension JSONDataWritable {
	static var outputFormatting: OutputFormatting { [] }
}
