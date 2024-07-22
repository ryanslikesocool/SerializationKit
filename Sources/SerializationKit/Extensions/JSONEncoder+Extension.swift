import Foundation

public extension JSONEncoder {
	/// The default shared instance.
	static let shared: JSONEncoder = JSONEncoder()

	/// Declaratively set the ``outputFormatting`` of the encoder.
	func with(outputFormatting: OutputFormatting) -> Self {
		self.outputFormatting = outputFormatting
		return self
	}
}
