import Foundation

public extension JSONEncoder {
	static let shared: JSONEncoder = JSONEncoder()

	func with(outputFormatting: OutputFormatting) -> Self {
		self.outputFormatting = outputFormatting
		return self
	}
}
