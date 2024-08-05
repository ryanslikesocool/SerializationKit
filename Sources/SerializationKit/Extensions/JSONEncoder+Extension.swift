import Foundation

public extension JSONEncoder {
	/// Declaratively set the ``outputFormatting`` of the encoder.
	func with(outputFormatting: OutputFormatting) -> Self {
		self.outputFormatting = outputFormatting
		return self
	}
}
