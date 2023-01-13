import Foundation

/// The base protocol for an object that can be serialized into an array of elements with the same type.
public protocol SerializedArrayConvertible: Serializable {
    //associatedtype SerializedElementType: SerializedObjectConvertible

    init(array: [RootSerializable])

	func toArray() -> [any Serializable]
}

public extension SerializedArrayConvertible {
	func serialize() -> RootSerializable {
		toArray().map { $0.serialize() }
	}
}

// public extension SerializedArrayConvertible where Self.SerializedType == Array<Self.SerializedElementType.SerializedType> {
//    init?(unwrap any: Any?) {
//        switch any {
//            case let this as Self: self = this
//            case let array as [SerializedElementType.SerializedType]: self.init(array: array)
//            default: return nil
//        }
//    }
//
//    func serialize() -> SerializedType {
//        toArray().map { $0.serialize() }
//    }
// }
