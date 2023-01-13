import Foundation

// extension Dictionary: SerializedObjectConvertible where Key == String, Value: SerializedObjectConvertible {
//	public func serialize() -> SerializedType {
//		reduce(into: SerializedType()) { result, element in
//			result[element.key] = element.value.serialize()
//		}
//	}
// }

// extension Dictionary: RootSerializable where Key: RootSerializable, Value == RootSerializable {
//
// }

extension Dictionary: SerializedDictionaryConvertible & Serializable where Key == String, Value: Serializable {
    public init(dictionary: [String: RootSerializable]) {
        self = dictionary.reduce(into: [Key: Value]()) { result, element in
            result[element.key] = Value(unwrap: element.value)
        }
    }

    public func toDictionary() -> [String: any Serializable] { self }
}

//public extension Serializable where Self == Dictionary<String, any Serializable> {
//    func serialize() -> RootSerializable {
//		(self as Dictionary<String, any Serializable>).reduce(into: [String: RootSerializable]()) { result, element in
//            result[element.key] = element.value.serialize()
//        }
//    }
//}
