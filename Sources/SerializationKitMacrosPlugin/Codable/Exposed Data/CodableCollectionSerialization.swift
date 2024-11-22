import enum SerializationKit_Core.CodableCollectionSerialization
import SwiftSyntax

extension CodableCollectionSerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("nested"): self = .nested
			case .identifier("inline"): self = .inline
			default: return nil
		}
	}
}
