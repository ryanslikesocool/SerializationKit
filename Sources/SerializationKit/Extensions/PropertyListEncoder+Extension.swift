import Foundation

public extension PropertyListEncoder {
	/// The default shared instance.
	static let shared: PropertyListEncoder = PropertyListEncoder()

	/// Declaratively set the ``outputFormat`` of the encoder.
	func with(outputFormat: PropertyListSerialization.PropertyListFormat) -> Self {
		self.outputFormat = outputFormat
		return self
	}
}
