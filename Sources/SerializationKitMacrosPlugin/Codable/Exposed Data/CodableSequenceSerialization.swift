import SwiftSyntax

/// Indicate how an unkeyed sequence should be serialized in an ``CodableObjectContainer/unkeyed`` container.
public enum CodableSequenceSerialization: UInt8 {
	/// Allow the sequence to be treated as a single object when serializing.
	case nested

	/// Inline the sequence when serializing.
	case inline

	// TODO: if more than one property is serialized, all inline sequences must be prefixed with a `count` value.
	// reorder serialization so sequences are serialized first
	// insert into the sequence for `count`, then continue to next property
}

// MARK: - Internal

extension CodableSequenceSerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("nested"): self = .nested
			case .identifier("inline"): self = .inline
			default: return nil
		}
	}
}
