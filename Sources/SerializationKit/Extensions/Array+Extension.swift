import Foundation

extension Array: SerializedArrayConvertible & SerializedObject where Element: SerializedObject, Element.RootSerializedType: RootSerializable {
    public typealias SerializedElement = Element
    public typealias RootSerializedType = Array<Element.RootSerializedType>

    public init(array: [SerializedElement]) {
        self = array
    }

    public func serialize() -> RootSerializedType {
        map { $0.serialize() }
    }
}
