import SerializationKitMacrosPlugin

/// Add custom coding support to an object.
@attached(extension, names: named(__CodingKeys), named(init(from:)), named(encode(to:)), conformances: Codable)
public macro Codable(_ containerMode: CodableObjectContainer = .keyed)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")

/// Indicate if a field should be serialized or not.
@attached(peer)
public macro Codable(_ serializationMode: CodablePropertySerialization)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")

/// Serialize a property with a different key.
@attached(peer)
public macro Codable(_ customKey: String)
	= #externalMacro(module: "SerializationKitMacrosPlugin", type: "CodableMacro")
