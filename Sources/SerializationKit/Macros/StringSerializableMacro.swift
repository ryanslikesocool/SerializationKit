@attached(extension, names: named(__CodingValues), named(init(from:)), named(encode), conformances: Codable)
public macro StringSerializable() = #externalMacro(module: "SerializationKitMacrosPlugin", type: "StringSerializableMacro")
