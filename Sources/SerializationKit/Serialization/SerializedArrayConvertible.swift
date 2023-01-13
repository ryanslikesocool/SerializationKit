import Foundation

/// The base protocol for an object that can be serialized into an array of elements with the same type.
public protocol SerializedArrayConvertible: Serializable {
    associatedtype SerializedElementType: SerializedObjectConvertible

    init(array: [SerializedElementType])
    func toArray() -> [Any]
}

public extension SerializedArrayConvertible {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let array as [SerializedElementType]: self.init(array: array)
            default: return nil
        }
    }

    func serialize() -> Any { toArray() }
}
