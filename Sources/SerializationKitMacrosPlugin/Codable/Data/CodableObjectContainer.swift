import SwiftSyntax

/// Container types for the ``Codable`` macro.
public enum CodableObjectContainer: UInt8 {
	/// Infer the best collection type to use to serialize an object.
//	case inferred

	/// Use a keyed container to serialize an object.
	case keyed

	/// Use a single-value container to serialize an object.
	case singleValue

	// TODO: smart implicit serialization from container type
	// .keyed
	//  - implicitly .serialized
	//  - implicitly .unserialized underscore prefixed properties
	// .unkeyed
	//  - implicitly .serialized if no linear collection present
	//  - implicitly .unserialized if one linear collection present
	//    - one linear collection is implicitly .serialized
	//    - perform special serialization for linear collection
	//  - implicitly .serialized if one linear collection is the only property
	//    - perform special serialization
 	// .singleValue
	//  - implicitly .serialized if only one property
	//  - implicitly .unserialized if more than one property

	// TODO: don't allow @Codable(_:String) in .singleValue

	// TODO: add .unkeyed support
	// if only an array or set should be serialized
}

// MARK: - Internal

extension CodableObjectContainer {
	static let associatedTokens: [TokenKind: Self] = [
		.identifier("keyed"): .keyed,
		.identifier("singleValue"): .singleValue,
	]
}
