import Foundation

extension Array: SerializedArrayConvertible & Serializable where Element: Serializable {
    public init(array: [RootSerializable]) {
        self = array.compactMap { Element(unwrap: $0) }
    }

    public func toArray() -> [any Serializable] { self }

    public func serialize() -> RootSerializable {
        map { $0.serialize() }
    }
}

public extension Serializable where Self == Array<any Serializable> {
    func serialize() -> RootSerializable {
        (self as Array<any Serializable>).map { $0.serialize() }
    }
}
