import Foundation

/// The base protocol for an object that can be serialized into a `[String: any SerializedObjectConvertible]` dictionary.
public protocol SerializedDictionaryConvertible: Serializable {
    init(dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}

public extension SerializedDictionaryConvertible {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let dictionary as [String: Any]: self.init(dictionary: dictionary)
            default: return nil
        }
    }

    func serialize() -> Any {
        toDictionary().reduce(into: [String: Any]()) { result, element in
            switch element.value {
                case let serialized as any Serializable: result[element.key] = serialized.serialize()
                default: result[element.key] = element.value
            }
        }
    }
}
