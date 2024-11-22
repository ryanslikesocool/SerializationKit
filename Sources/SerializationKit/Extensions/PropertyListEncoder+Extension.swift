import Foundation

public extension PropertyListEncoder {
	/// Declaratively set the ``outputFormat`` of the encoder.
	func with(outputFormat: PropertyListSerialization.PropertyListFormat) -> Self {
		self.outputFormat = outputFormat
		return self
	}
}
