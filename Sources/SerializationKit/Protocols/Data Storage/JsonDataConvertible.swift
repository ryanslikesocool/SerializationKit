import Foundation

public protocol JsonDataConvertible: SerializedDataConvertible {
	static var outputFormatting: JSONEncoder.OutputFormatting { get }
	
	func toData(outputFormatting: JSONEncoder.OutputFormatting) throws -> Data
}

public extension JsonDataConvertible {
	static var outputFormatting: JSONEncoder.OutputFormatting { [] }
}
