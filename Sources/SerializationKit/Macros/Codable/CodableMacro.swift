import SerializationKitMacrosPlugin

/// Add custom coding support to an object.
@attached(extension, names: named(__CodingKeys), named(init(from:)), named(encode(to:)), conformances: Codable)
public macro Codable(_ containerMode: CodableObjectContainer = .keyed)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")

/// Indicate if a property should be serialized or not.
@attached(peer)
public macro Codable(_ serialization: CodablePropertySerialization)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")

/// Serialize a property with a custom key.
/// - Remark: This attribute will also indicate that the property should be serialized.
@attached(peer)
public macro Codable(_ customKey: String)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")

/// Indicate how an unkeyed sequence should be serialized.
//@attached(peer)
//public macro Codable(_ sequenceSerialization: CodableSequenceSerialization)
//	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")