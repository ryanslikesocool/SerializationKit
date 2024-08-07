import SwiftSyntax

/// Indicate if a property should be serialized or not.
@frozen
public enum CodablePropertySerialization: UInt8 {
	/// Indicates that a field should be serialized.
	///
	/// This is the default value.
	case serialized

	/// Indicates that a field should not be serialized.
	///
	/// - Remark: Unserialized properties must either be optional or declare a default value.
	case unserialized
}

// MARK: - Internal

extension CodablePropertySerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("serialized"): self = .serialized
			case .identifier("unserialized"): self = .unserialized
			default: return nil
		}
	}
}
