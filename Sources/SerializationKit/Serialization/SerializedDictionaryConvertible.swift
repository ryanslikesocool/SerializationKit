import Foundation

/// The base protocol for an object that can be serialized into a `[String: any SerializedObjectConvertible]` dictionary.
public protocol SerializedDictionaryConvertible: Serializable {
    init(dictionary: [String: any Serializable])
    func toDictionary() -> [String: Any]
}

public extension SerializedDictionaryConvertible {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let dictionary as [String: any Serializable]: self.init(dictionary: dictionary)
            default: return nil
        }
    }

    func serialize() -> Any { toDictionary() }
}
