import Foundation

/// The `RootSerializable` protocol.  You should not extend this unless you know the internals off`SerializationKit`.
///
/// The basic serializable types are as folllows:
/// - `String`
/// - Floating point types `Float` and `Double`
/// - Integer types `Int8`, `Int16`, `Int32`, `Int64`, and `Int`
/// - Unsigned integer types `UInt8`, `UInt16`, `UInt32`, `UInt64`, and `UInt`
/// - Arrays where the elements are `RootSerializable`
/// - Dictionaries where the keys are string and the elements is `RootSerializable`
public protocol RootSerializable {}

// MARK: - Default Implementation

public extension RootSerializable where Self: SerializedObjectConvertible {
    func serialize() -> RootSerializable { self }
}

public extension RootSerializable where Self: SerializedArrayConvertible {
    func serialize() -> RootSerializable { self }
}

public extension RootSerializable where Self: SerializedDictionaryConvertible {
    func serialize() -> RootSerializable { self }
}

// MARK: - Provided Conformance

extension Bool: RootSerializable { }
extension String: RootSerializable { }

extension Float: RootSerializable { }
extension Double: RootSerializable { }

extension Int8: RootSerializable { }
extension Int16: RootSerializable { }
extension Int32: RootSerializable { }
extension Int64: RootSerializable { }
extension Int: RootSerializable { }

extension UInt8: RootSerializable { }
extension UInt16: RootSerializable { }
extension UInt32: RootSerializable { }
extension UInt64: RootSerializable { }
extension UInt: RootSerializable { }

extension Array: RootSerializable where Element == RootSerializable {}

extension Dictionary: RootSerializable where Key == String, Value == RootSerializable {}
