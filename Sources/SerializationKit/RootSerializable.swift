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
public protocol RootSerializable {}

public extension SerializedObject where Self: RootSerializable, Self.RootSerializedType == Self {
    func serialize() -> Self { self }
}

// MARK: - Provided Conformance

extension Bool: RootSerializable & SerializedObject {}
extension String: RootSerializable & SerializedObject {}

extension Float: RootSerializable & SerializedObject { }
extension Double: RootSerializable & SerializedObject { }

extension Int8: RootSerializable & SerializedObject { }
extension Int16: RootSerializable & SerializedObject { }
extension Int32: RootSerializable & SerializedObject { }
extension Int64: RootSerializable & SerializedObject { }
extension Int: RootSerializable & SerializedObject { }

extension UInt8: RootSerializable & SerializedObject { }
extension UInt16: RootSerializable & SerializedObject { }
extension UInt32: RootSerializable & SerializedObject { }
extension UInt64: RootSerializable & SerializedObject { }
extension UInt: RootSerializable & SerializedObject { }

extension Array: RootSerializable where Element: RootSerializable {}

extension Dictionary: RootSerializable where Key == String, Value == any RootSerializable {}
