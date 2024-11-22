import enum SerializationKit_Core.CodablePropertySerialization
import SwiftSyntax

extension CodablePropertySerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("serialized"): self = .serialized
			case .identifier("unserialized"): self = .unserialized
			default: return nil
		}
	}
}
