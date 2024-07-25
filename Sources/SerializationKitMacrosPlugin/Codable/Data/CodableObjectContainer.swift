import SwiftSyntax

/// Container types for the ``Codable`` macro.
public enum CodableObjectContainer: UInt8 {
	/// Infer the best collection type to use to serialize an object.
//	case inferred

	/// Use a keyed container to serialize an object.
	case keyed

	/// Use an unkeyed container to serialize an object.
//	case unkeyed

	/// Use a single-value container to serialize an object.
	case singleValue

	// TODO: smart implicit serialization from container type
	// always
	//  - implicitly .unserialized underscore prefixed properties - can't really do this unless default values are provided?
	// .keyed
	//  - implicitly .serialized
	// .unkeyed
	//  - linear collections always inline serialization
	//  - implicitly .serialized if no linear collection present
	//  - implicitly .unserialized if one linear collection present
	//    - one linear collection is implicitly .serialized
	//    - perform special serialization for linear collection
	//  - implicitly .serialized if one linear collection is the only property
	// .singleValue
	//  - implicitly .serialized if only one property
	//  - implicitly .unserialized if more than one property

	// TODO: don't allow @Codable(_:String) in .unkeyed or .singleValue
	// suggest for user to explicitly set container mode to .keyed if @Codable(_:String) is actually desired

	// TODO: support @Codable(_:String...) for declarations with multiple bindings

	// TODO: don't allow @Codable(_:CodableSequenceSerialization.inline) in .keyed or .singleValue
	// recommend for user to remove @Codable(_:CodableSequenceSerialization.lazy) if present

	// TODO: merge StringCodableMacro into CodableMacro
	// @Codable(.asString)
	// if i did it like that, i could also do .asInteger for enums with primary type of String
	// would this be possible to allow on a per-property basis?  is that a bad idea?
}

// MARK: - Internal

extension CodableObjectContainer {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
//			case .identifier("inferred"): self = .inferred
			case .identifier("keyed"): self = .keyed
//			case .identifier("unkeyed"): self = .unkeyed
			case .identifier("singleValue"): self = .singleValue
			default: return nil
		}
	}
}
