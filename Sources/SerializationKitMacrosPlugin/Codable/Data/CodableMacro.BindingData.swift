import SwiftSyntax

extension CodableMacro {
	struct BindingData {
		typealias AttributeArgument = CodableMacro.AttributeArgument
		typealias Diagnostic = CodableMacro.Diagnostic

		let type: TypeSyntax
		let sourceType: TypeSyntax
		let optionalType: OptionalTypeSyntax

		let name: TokenSyntax

		let customCodingKey: TokenSyntax?
		let collectionSerialization: CodableCollectionSerialization?

		private let optionalSerializationFlags: OptionalSerializationFlags

		var providesDefault: Bool { optionalSerializationFlags.contains(.providesDefault) }
		var isOptional: Bool { optionalSerializationFlags.contains(.isOptional) }

		init?(defaultType: TypeSyntax, binding: PatternBindingSyntax, arguments: borrowing [AttributeArgument]) throws {
			guard binding.accessorBlock == nil else {
				return nil
			}

			sourceType = binding.typeAnnotation?.type.trimmed ?? defaultType

			type = if let optionalType = sourceType.as(OptionalTypeSyntax.self) {
				optionalType.wrappedType.trimmed
			} else if let implicitlyUnwrappedOptional = sourceType.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
				implicitlyUnwrappedOptional.wrappedType.trimmed
			} else {
				sourceType
			}
			optionalType = OptionalTypeSyntax(wrappedType: type)

			let (serialized, customCodingKey, collectionSerialization) = try Self.processArguments(arguments)
			guard serialized else {
				return nil
			}
			self.customCodingKey = customCodingKey
			self.collectionSerialization = collectionSerialization

			guard let bindingPattern = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
				throw Diagnostic.invalidBindingPattern
			}
			name = bindingPattern

			optionalSerializationFlags = OptionalSerializationFlags(binding: binding, type: sourceType)
		}
	}
}

private extension CodableMacro.BindingData {
	static func processArguments(_ arguments: [AttributeArgument]) throws -> (
		serialized: Bool,
		customCodingKey: TokenSyntax?,
		collectionSerialization: CodableCollectionSerialization?
	) {
		var occupiedArguments: AllowedArguments = .none

		var serialized: Bool = true
		var customCodingKey: TokenSyntax? = nil
		var collectionSerialization: CodableCollectionSerialization? = nil

		loop: for argument in arguments {
			var inserting: AllowedArguments? = nil

			switch argument {
				case let .propertySerialization(propertySerialization):
					inserting = .propertySerialization
					if propertySerialization == .unserialized {
						serialized = false
						break loop
					}
				case let .propertyCustomKey(customKey):
					inserting = .propertyCustomKey
					customCodingKey = customKey
				case let .collectionSerialization(serialization):
					collectionSerialization = serialization
					if serialization == .inline {
						inserting = .collectionSerializationInline
					} else {
						inserting = .collectionSerialization
					}
				default:
					break
			}

			if
				let inserting,
				!occupiedArguments.insert(inserting).inserted
			{
				throw Diagnostic.duplicateArgument
			}
		}

		return (serialized, customCodingKey, collectionSerialization)
	}
}

// MARK: - Supporting Data

private extension CodableMacro.BindingData {
	struct AllowedArguments: OptionSet {
		let rawValue: UInt8

		static let none: Self = Self(rawValue: 0)
		static let propertySerialization: Self = Self(rawValue: 1 << 0)
		static let propertyCustomKey: Self = Self(rawValue: 1 << 1)

		static let collectionSerialization: Self = Self(rawValue: 1 << 2)
		static let collectionSerializationInline: Self = [.collectionSerialization, .propertyCustomKey]
	}
}
