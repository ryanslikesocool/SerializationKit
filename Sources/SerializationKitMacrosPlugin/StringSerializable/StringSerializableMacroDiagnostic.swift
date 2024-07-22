import SwiftDiagnostics

enum StringSerializableMacroDiagnostic: String, Error {
	case enumOnly
	case requiresPrimaryNumericType
	case notEmpty
}

extension StringSerializableMacroDiagnostic: DiagnosticMessage {
	var severity: DiagnosticSeverity { .error }

	var diagnosticID: MessageID { MessageID(domain: "SerializationKitMacrosPlugin", id: rawValue) }

	var message: String {
		switch self {
			case .enumOnly: "@StringSerializable may only be attached to an enum declaration."
			case .requiresPrimaryNumericType: "@StringSerializable requires a primary numeric type."
			case .notEmpty: "@StringSerializable requires at least one enum case."
		}
	}
}
