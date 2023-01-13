import Foundation

extension SIMD2: SerializedObjectConvertible & Serializable where Scalar: SerializedObjectConvertible {}

extension SIMD3: SerializedObjectConvertible & Serializable where Scalar: SerializedObjectConvertible {}

extension SIMD4: SerializedObjectConvertible & Serializable where Scalar: SerializedObjectConvertible {}

public extension SerializedObjectConvertible where Self: SIMD, Self.Scalar: SerializedObjectConvertible {
    init(array: [Scalar]) {
        self.init(array)
    }

    func serialize() -> Any {
        indices.map { self[$0].serialize() }
    }
}
