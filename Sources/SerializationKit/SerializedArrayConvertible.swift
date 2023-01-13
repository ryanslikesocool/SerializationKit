import Foundation

/// The base protocol for an object that can be serialized into an array of elements with the same type.
public protocol SerializedArrayConvertible: SerializedObject {
    associatedtype SerializedElement: SerializedObject

    init(array: [SerializedElement])
}

public extension SerializedArrayConvertible {
    init?(unwrap any: Any?) {
        switch any {
			case let this as Self: self = this
            case let array as [SerializedElement]: self.init(array: array)
            default: return nil
        }
    }
}
