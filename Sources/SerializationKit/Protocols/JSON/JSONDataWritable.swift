import Foundation

public protocol JSONDataWritable: SerializedDataWritable {
	static var outputFormatting: JSONEncoder.OutputFormatting { get }
	
	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data
}

public extension JSONDataWritable {
	static var outputFormatting: JSONEncoder.OutputFormatting { [] }
}
