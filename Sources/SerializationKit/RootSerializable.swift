import Foundation

/// The root serializable protocol.  You should not extend this.
///
/// The basic serializable types are as folllows.
/// - `String`
/// - Floating point types `Float` and `Double`
/// - Integer types `Int8`, `Int16`, `Int32`, `Int64`, and `Int`
/// - Unsigned integer types `UInt8`, `UInt16`, `UInt32`, `UInt64`, and `UInt`
/// - Arrays where the elements are a serializable type
/// - Dictionaries where the keys are string and the elements are serializable types (NOT IMPLEMENTED)
public protocol RootSerializable: SerializedObject {}

public extension RootSerializable where Self.RootSerializedType == Self {
    func serialize() -> Self { self }
}

extension Bool: RootSerializable {
    public typealias RootSerializedType = Self
}

extension String: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Float: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Double: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Int8: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Int16: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Int32: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Int64: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Int: RootSerializable {
    public typealias RootSerializedType = Self
}

extension UInt8: RootSerializable {
    public typealias RootSerializedType = Self
}

extension UInt16: RootSerializable {
    public typealias RootSerializedType = Self
}

extension UInt32: RootSerializable {
    public typealias RootSerializedType = Self
}

extension UInt64: RootSerializable {
    public typealias RootSerializedType = Self
}

extension UInt: RootSerializable {
    public typealias RootSerializedType = Self
}

extension Array: RootSerializable where Element: RootSerializable {
    public typealias SerializedType = Self
}

// extension Dictionary: RootSerializable where Key == String, Value == any RootSerializable {
//
// }
