import SwiftSyntax

/// Indicate how an `enum` should be serialized.
/// - Remark: This is only available for `enum`s that declare a primary value.
public enum CodableEnumSerialization: UInt8 {
	/// Indicate that an `enum` should be serialized by case name.
	case asString

	/// Indicate that an `enum` should be serialized by case index.
	case asInteger

	// TODO: look into doing this on a per-case basis
	// is that a bad idea?
}

// MARK: - Internal

extension CodableEnumSerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("asString"): self = .asString
			case .identifier("asInteger"): self = .asInteger
			default: return nil
		}
	}
}
