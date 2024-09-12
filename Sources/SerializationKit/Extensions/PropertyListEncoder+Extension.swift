import Foundation

public extension PropertyListEncoder {
	/// Declaratively set the ``outputFormat`` of the encoder.
	@inlinable @inline(__always)
	func with(outputFormat: PropertyListSerialization.PropertyListFormat) -> Self {
		self.outputFormat = outputFormat
		return self
	}
}
