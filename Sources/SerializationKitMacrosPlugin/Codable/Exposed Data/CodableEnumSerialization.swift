import enum SerializationKit_Core.CodableEnumSerialization
import SwiftSyntax

extension CodableEnumSerialization {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
			case .identifier("asString"): self = .asString
			case .identifier("asInteger"): self = .asInteger
			default: return nil
		}
	}
}
