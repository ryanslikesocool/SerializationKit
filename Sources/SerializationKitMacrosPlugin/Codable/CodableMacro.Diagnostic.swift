import SwiftDiagnostics

extension CodableMacro {
	enum Diagnostic: String, Error {
		// Extension
		case classOrStructOnly
		case notEmpty
		case invalidSingleValue
		case invalidBindingPattern
		case typeUnwrapFailure

		// Member
		case storedPropertiesOnly
		case singleBindingOrNoInitializer
		case requiresExplicitTypeAnnotation
		case unserializedRequiresDefault
		case customKeySingleBinding
		case onlyOneAttribute
		case staticStringLiteral
	}
}

extension CodableMacro.Diagnostic: DiagnosticMessage {
	var severity: DiagnosticSeverity { .error }

	var diagnosticID: MessageID { MessageID(domain: "SerializationKitMacrosPlugin", id: rawValue) }

	var message: String {
		switch self {
			case .classOrStructOnly: "@\(Self.macroName) may only be applied to a class or struct declaration."
			case .notEmpty: "@\(Self.macroName) requires that the object it is attached to has at least one property."
			case .invalidSingleValue: "@\(Self.macroName) with a `.singleValue` container requires the object it is attached to has exactly one property, or has all but one property marked as `.unserialized`."
			case .invalidBindingPattern: "@\(Self.macroName) encountered an unexpected issue when processing a binding pattern.  Please file a bug report."
			case .typeUnwrapFailure: "@\(Self.macroName) encountered an unexpected issue when unwrapping a type.  Please file a bug report."
			
			case .storedPropertiesOnly: "@\(Self.macroName) may only be applied to stored properties."
			case .singleBindingOrNoInitializer: "@\(Self.macroName) currently only supports one property binding, or multiple property bindings with no initializers."
			case .requiresExplicitTypeAnnotation: "@\(Self.macroName) requires that the property it is attached to has an explicit type annotation."
			case .unserializedRequiresDefault: "@\(Self.macroName) requires that properties marked as `.unserialized` are either optional or have a default value."
			case .customKeySingleBinding: "@\(Self.macroName) with a custom key may only be applied to a variable declaration with a single binding."
			case .onlyOneAttribute: "@\(Self.macroName) may only be applied once per property."
			case .staticStringLiteral: "@\(Self.macroName) may only use a static string literal as a custom coding key."
		}
	}

	private static let macroName: String = "Codable"
}
