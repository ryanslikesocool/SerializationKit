import Foundation

/// The base protocol for an object that can be serialized into a `[String: any SerializedObject]` dictionary.
public protocol SerializedDictionaryConvertible: Serializable {
    // associatedtype SerializedKeyType: SerializedObjectConvertible
    // associatedtype SerializedValueType: SerializedObjectConvertible

    init(dictionary: [String: RootSerializable])

    func toDictionary() -> [String: any Serializable]
}

public extension SerializedDictionaryConvertible {
    func serialize() -> RootSerializable {
        toDictionary().reduce(into: [String: RootSerializable]()) { result, element in
            result[element.key] = element.value.serialize()
        }
    }
}

// public extension SerializedDictionaryConvertible {
//    init?(unwrap any: Any?) {
//        switch any {
//            case let this as Self: self = this
//            case let dictionary as [String: RootSerializable]: self.init(dictionary: dictionary)
//            default: return nil
//        }
//    }
//
//    func serialize() -> SerializedType {
//        toDictionary().reduce(into: [RootSerializable: RootSerializable](), { result, element in
//            result[element.key] = element.value.serialize()
//        })
//    }
// }
