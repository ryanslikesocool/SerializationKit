import Foundation

public protocol JsonDataWritable: SerializedDataWritable {
	static var outputFormatting: JSONEncoder.OutputFormatting { get }
	
	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data
}

public extension JsonDataWritable {
	static var outputFormatting: JSONEncoder.OutputFormatting { [] }
}
