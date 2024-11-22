import enum SerializationKit_Core.CodableObjectContainer
import SwiftSyntax

extension CodableObjectContainer {
	init?(_ tokenKind: TokenKind) {
		switch tokenKind {
//			case .identifier("inferred"): self = .inferred
			case .identifier("keyed"): self = .keyed
//			case .identifier("unkeyed"): self = .unkeyed
			case .identifier("singleValue"): self = .singleValue
			default: return nil
		}
	}
}
