import Foundation

/// The `Serializable` protocol.  You should not extend this unless you know the internals off`SerializationKit`.
public protocol Serializable {
    init?(unwrap any: Any?)
    init(unwrap any: Any?, default: Self)

    // TODO: add initialized
    // init?(serialized: SerializedType)

    /// Convert the instance to a root serializable type.
    /// See: ``RootSerializable``
    func serialize() -> RootSerializable
}

public extension Serializable {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            default: return nil
        }
    }

    init(unwrap any: Any?, default: Self) {
        self = Self(unwrap: any) ?? `default`
    }
}
