import Foundation

/// The base protocol for any object that can be serialized into data.
public protocol SerializedObject {
    associatedtype RootSerializedType: RootSerializable

    init?(unwrap any: Any?)

    // TODO: add initialized
    // init?(serialized: RootSerializedType)

    /// Convert the instance to a root serializable type.
	/// See: ``RootSerializable``
    func serialize() -> RootSerializedType
}

public extension SerializedObject {
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

// MARK: - Provided

extension Date: SerializedObject { }
extension UUID: SerializedObject { }
