import SwiftDiagnostics

extension StringCodableMacro {
	enum Diagnostic: String, Error {
		case enumOnly
		case requiresPrimaryNumericType
		case notEmpty
	}
}

extension StringCodableMacro.Diagnostic: DiagnosticMessage {
	var severity: DiagnosticSeverity { .error }

	var diagnosticID: MessageID { MessageID(domain: "SerializationKitMacrosPlugin", id: rawValue) }

	var message: String {
		switch self {
			case .enumOnly: "\(Self.macroName) may only be attached to an enum declaration."
			case .requiresPrimaryNumericType: "\(Self.macroName) requires a primary numeric type."
			case .notEmpty: "\(Self.macroName) requires at least one enum case."
		}
	}

	private static let macroName: String = "StringCodable"
}
