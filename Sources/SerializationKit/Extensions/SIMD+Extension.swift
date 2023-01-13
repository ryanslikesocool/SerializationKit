import Foundation

extension SIMD2: SerializedArrayConvertible & SerializedObject where Scalar: SerializedObject {
    public typealias RootSerializedType = Array<Scalar.RootSerializedType>
}

extension SIMD3: SerializedArrayConvertible & SerializedObject where Scalar: SerializedObject {
    public typealias RootSerializedType = Array<Scalar.RootSerializedType>
}

extension SIMD4: SerializedArrayConvertible & SerializedObject where Scalar: SerializedObject {
    public typealias RootSerializedType = Array<Scalar.RootSerializedType>
}

public extension SerializedArrayConvertible where Self: SIMD, Self.Scalar: SerializedObject, Self.SerializedElement == Scalar {
    typealias SerializedType = Array<Scalar.RootSerializedType>

    init(array: [SerializedElement]) {
        self.init(array)
    }

    func serialize() -> Self.RootSerializedType {
        indices.map { self[$0].serialize() } as! Self.RootSerializedType
    }
}
