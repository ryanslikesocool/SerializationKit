import Foundation

public protocol Serializable {
	init?(unwrap any: Any?)
	init(unwrap any: Any?, default: Self)

	/// Convert the instance to a serializable type.
	///
	/// The basic serializable types are as folllows.
	/// - `String`
	/// - Floating point types `Float` and `Double`
	/// - Integer types `Int8`, `Int16`, `Int32`, `Int64`, and `Int`
	/// - Unsigned integer types `UInt8`, `UInt16`, `UInt32`, `UInt64`, and `UInt`
	/// - Arrays where the elements are a serializable type
	/// - Dictionaries where the keys are string and the elements are serializable types
	/// - Returns: The serialized instance.
	func serialize() -> Any
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
