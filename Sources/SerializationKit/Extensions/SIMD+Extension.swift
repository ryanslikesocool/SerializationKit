import Foundation

extension SIMD2: SerializedArrayConvertible & Serializable where Scalar: SerializedObjectConvertible { }

extension SIMD3: SerializedArrayConvertible & Serializable where Scalar: SerializedObjectConvertible { }

extension SIMD4: SerializedArrayConvertible & Serializable where Scalar: SerializedObjectConvertible { }

public extension SerializedArrayConvertible where Self: SIMD, Self.Scalar: SerializedObjectConvertible {
	init(array: [Scalar]) {
		self.init(array)
	}

	func toArray() -> [Any] {
		indices.map { self[$0] }
	}

	func serialize() -> Any {
		indices.map { self[$0].serialize() }
	}
}
