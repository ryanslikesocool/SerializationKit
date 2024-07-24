/// Serialize an `enum` as a ``Swift/String`` to avoid issues when reordering or adding cases.
///
/// # Usage:
/// Add the `@StringCodable` macro to an `enum` declaration.
/// The `enum`'s primary type must be a fixed-width integer.
/// ```swift
/// @StringCodable
///	enum MyIntegerEnum: Int16 {
///	    case zero
///	    case one
///	    case two
///	}
/// ```
@attached(extension, names: named(__CodingValues), named(init(from:)), named(encode), conformances: Codable)
public macro StringCodable() = #externalMacro(module: "SerializationKitMacrosPlugin", type: "StringCodableMacro")
