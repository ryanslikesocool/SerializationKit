import SwiftSyntax

extension CodableMacro {
	struct OptionalSerializationFlags: OptionSet {
		let rawValue: UInt8

		static let providesDefault: Self = Self(rawValue: 1 << 0)
		static let isOptional: Self = Self(rawValue: 1 << 1)
		static let isIgnored: Self = Self(rawValue: 1 << 2)

		init(rawValue: RawValue) {
			self.rawValue = rawValue
		}

		init(binding: PatternBindingSyntax, type: TypeSyntax) {
			self.init(rawValue: RawValue.zero)
			if binding.initializer != nil {
				insert(.providesDefault)
			}
			if type.is(OptionalTypeSyntax.self) {
				insert(.isOptional)
			}
		}
	}
}
