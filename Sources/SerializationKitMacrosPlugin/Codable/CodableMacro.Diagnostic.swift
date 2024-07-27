import SwiftDiagnostics

extension CodableMacro {
	enum Diagnostic: String, Error {
		// Peer Macro (Validation)
		case invalidAttributeContext
		case classOrStructOnly
		case enumOnly

		// Arguments
		case invalidAttributeArgument
		case duplicateArgument

		// Enum
		case missingEnumSerialization
		case enumNotEmpty

		// Extension Macro
		case objectNotEmpty
		case invalidSingleValue
		case invalidBindingPattern
		case typeUnwrapFailure

		// Member
		case noEnumAssociatedValues
		case storedPropertiesOnly
		case onlyOneAttribute

		case singleBindingOrNoInitializer
		case requiresExplicitTypeAnnotation
		case unserializedRequiresDefault

		// Member/Custom Key
		case customKeySingleBinding
		case staticStringLiteral
	}
}

extension CodableMacro.Diagnostic: DiagnosticMessage {
	var severity: DiagnosticSeverity { .error }

	var diagnosticID: MessageID { MessageID(domain: "SerializationKitMacrosPlugin", id: rawValue) }

	var message: String {
		switch self {
			case .invalidAttributeContext: "@\(Self.macroName) cannot be applied in this context."
			case .classOrStructOnly: "@\(Self.macroName) may only be applied to a class or struct declaration."
			case .enumOnly: "@\(Self.macroName) may only be applied to an enum declaration."

			case .invalidAttributeArgument: "@\(Self.macroName) was passed an invalid argument."
			case .duplicateArgument: "@\(Self.macroName) was passed a duplicate argument."

			case .missingEnumSerialization: "@\(Self.macroName) requires a `CodableEnumSerialization` argument when applied to an `enum` declaration."
			case .enumNotEmpty: "@\(Self.macroName) may not be applied to an `enum` with no cases."

			case .objectNotEmpty: "@\(Self.macroName) requires that the object it is attached to has at least one property."
			case .invalidSingleValue: "@\(Self.macroName) with a `.singleValue` container requires the object it is attached to has exactly one property, or has all but one property marked as `.unserialized`."
			case .invalidBindingPattern: "@\(Self.macroName) encountered an unexpected issue when processing a binding pattern.  Please file a bug report."
			case .typeUnwrapFailure: "@\(Self.macroName) encountered an unexpected issue when unwrapping a type.  Please file a bug report."

			case .noEnumAssociatedValues: "@\(Self.macroName) may not be applied to `enum`s with associated values."
			case .storedPropertiesOnly: "@\(Self.macroName) may only be applied to stored properties."
			case .onlyOneAttribute: "@\(Self.macroName) may only be applied once per declaration."

			case .singleBindingOrNoInitializer: "@\(Self.macroName) currently only supports one property binding with or without an initializer, or multiple property bindings with no initializers."
			case .requiresExplicitTypeAnnotation: "@\(Self.macroName) requires that the property it is attached to has an explicit type annotation."
			case .unserializedRequiresDefault: "@\(Self.macroName) requires that properties marked as `.unserialized` are either optional or have a default value."

			case .customKeySingleBinding: "@\(Self.macroName) with a custom key may only be applied to a variable declaration with a single binding."
			case .staticStringLiteral: "@\(Self.macroName) may only use a static string literal as a custom coding key."
		}
	}

	private static let macroName: String = "Codable"
}
