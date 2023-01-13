import Foundation

/// The base protocol for an object that can be serialized into a `[String: any SerializedObject]` dictionary.
public protocol SerializedDictionaryConvertible: SerializedObject where Self.RootSerializedType == [String: any RootSerializable] {
    init(dictionary: [String: any RootSerializable])
    func toDictionary() -> [String: any SerializedObject]
}

public extension SerializedDictionaryConvertible {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let dictionary as [String: any RootSerializable]: self.init(dictionary: dictionary)
            default: return nil
        }
    }

    func serialize() -> [String: any RootSerializable] {
        toDictionary().reduce(into: [String: any RootSerializable](), { result, element in
            result[element.key] = element.value.serialize()
        })
    }
}
