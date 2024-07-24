import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension CodableMacro: ExtensionMacro {
	public static func expansion(
		of node: AttributeSyntax,
		attachedTo declaration: some DeclGroupSyntax,
		providingExtensionsOf type: some TypeSyntaxProtocol,
		conformingTo protocols: [TypeSyntax],
		in context: some MacroExpansionContext
	) throws -> [ExtensionDeclSyntax] {
		try validateDeclaration(declaration)
		let bindings: [BindingData] = try retrieveBindings(in: declaration)
		let container: CodableObjectContainer = try retrieveContainerType(in: node, from: bindings)

		try validateContainerBindings(bindings: bindings, container: container)

		return try [
			buildExtensionBlock(type: type, bindings: bindings, container: container),
		]
	}
}

// MARK: - Syntax Processing

private extension CodableMacro {
	static func validateDeclaration(_ declaration: some DeclGroupSyntax) throws {
		guard
			declaration.is(ClassDeclSyntax.self)
			|| declaration.is(StructDeclSyntax.self)
		else {
			throw Diagnostic.classOrStructOnly
		}
	}

	static func validateContainerBindings(bindings: [BindingData], container: CodableObjectContainer) throws {
		if
			container == .singleValue,
			bindings.count > 1
		{
			throw Diagnostic.invalidSingleValue
		}
	}

	static func retrieveBindings(in declaration: some DeclGroupSyntax) throws -> [BindingData] {
		try declaration.memberBlock.members
			.compactMap { member in member.decl.as(VariableDeclSyntax.self) }
			.flatMap { property -> [BindingData] in
				let argument: MemberAttributeArgument? = try validateMemberAttribute(property)
				return try processSerializedBindings(in: property, argument: argument)
			}
	}

	static func processSerializedBindings(in declaration: VariableDeclSyntax, argument: MemberAttributeArgument?) throws -> [BindingData] {
		let lastBindingType: TypeSyntax = try validateBindings(in: declaration, argument: argument)
		return try declaration.bindings.compactMap { binding in
			try BindingData(defaultType: lastBindingType, binding: binding, argument: argument)
		}
	}

	static func retrieveContainerType(in attribute: AttributeSyntax, from bindings: [BindingData]) throws -> CodableObjectContainer {
		guard
			let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
			let expression = arguments.first?.expression,
			let memberAccess = expression.as(MemberAccessExprSyntax.self),
			let token = memberAccess.lastToken(viewMode: .fixedUp)?.tokenKind,
			let container = CodableObjectContainer.associatedTokens[token]
		else {
			return retrieveDefaultContainerType(from: bindings)
		}
		return container
	}

	static func retrieveDefaultContainerType(from bindings: [BindingData]) -> CodableObjectContainer {
		if bindings.count == 1 {
			.singleValue
		} else {
			.keyed
		}
	}
}

// MARK: - String Builder

private extension CodableMacro {
	static func buildCodingKeysEnum(_ bindings: [BindingData]) throws -> EnumDeclSyntax {
		try EnumDeclSyntax("private enum __CodingKeys: String, CodingKey") {
			for binding in bindings {
				if let customCodingKey = binding.customCodingKey {
					"    case \(binding.name) = \"\(customCodingKey)\""
				} else {
					"    case \(binding.name)"
				}
			}
		}
	}

	static func buildDecoderBlock(_ bindings: [BindingData], container: CodableObjectContainer) throws -> InitializerDeclSyntax {
		let containerDeclaration: CodeBlockItemSyntax = switch container {
			case .keyed: "    let container = try decoder.container(keyedBy: __CodingKeys.self)"
			case .singleValue: "    let container = try decoder.singleValueContainer()"
		}

		return try InitializerDeclSyntax("public init(from decoder: any Decoder) throws") {
			containerDeclaration

			switch container {
				case .keyed:
					for binding in bindings {
						if binding.providesDefault {
							try IfExprSyntax("    if let \(binding.name) = try container.decodeIfPresent(\(binding.type).self, forKey: __CodingKeys.\(binding.name))") {
								"        self.\(binding.name) = \(binding.name)"
							}
						} else if binding.isOptional {
							"    self.\(binding.name) = try container.decodeIfPresent(\(binding.type).self, forKey: __CodingKeys.\(binding.name))"
						} else {
							"    self.\(binding.name) = try container.decode(\(binding.type).self, forKey: __CodingKeys.\(binding.name))"
						}
					}
				case .singleValue:
					for binding in bindings {
						if binding.providesDefault {
							try IfExprSyntax("    if let \(binding.name) = try container.decode(\(binding.optionalType).self)") {
								"        self.\(binding.name) = \(binding.name)"
							}
						} else if binding.isOptional {
							"    self.\(binding.name) = try container.decode(\(binding.optionalType).self)"
						} else {
							"    self.\(binding.name) = try container.decode(\(binding.type).self)"
						}
					}
			}
		}
	}

	static func buildEncoderBlock(_ bindings: [BindingData], container: CodableObjectContainer) throws -> FunctionDeclSyntax {
		let containerDeclaration: CodeBlockItemSyntax = switch container {
			case .keyed: "    var container = encoder.container(keyedBy: __CodingKeys.self)"
			case .singleValue: "    var container = encoder.singleValueContainer()"
		}

		return try FunctionDeclSyntax("public func encode(to encoder: any Encoder) throws") {
			containerDeclaration

			switch container {
				case .keyed:
					for binding in bindings {
						if binding.isOptional {
							"    try container.encodeIfPresent(\(binding.name), forKey: __CodingKeys.\(binding.name))"
						} else {
							"    try container.encode(\(binding.name), forKey: __CodingKeys.\(binding.name))"
						}
					}
				case .singleValue:
					for binding in bindings {
						if binding.isOptional {
							"    try container.encode(\(binding.name))"
						} else {
							"    try container.encode(\(binding.name))"
						}
					}
			}
		}
	}

	static func buildExtensionBlock(
		type: some TypeSyntaxProtocol,
		bindings: [BindingData],
		container: CodableObjectContainer
	) throws -> ExtensionDeclSyntax {
		try ExtensionDeclSyntax("extension \(type.trimmed): Codable") {
			if container == .keyed {
				try buildCodingKeysEnum(bindings)
			}
			try buildDecoderBlock(bindings, container: container)
			try buildEncoderBlock(bindings, container: container)
		}
	}
}

// MARK: - Supporting Data

private extension CodableMacro {
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

	struct BindingData {
		let type: TypeSyntax
		let sourceType: TypeSyntax
		let optionalType: OptionalTypeSyntax

		let name: TokenSyntax
		let customCodingKey: TokenSyntax?
		private let optionalSerializationFlags: OptionalSerializationFlags

		var providesDefault: Bool { optionalSerializationFlags.contains(.providesDefault) }
		var isOptional: Bool { optionalSerializationFlags.contains(.isOptional) }

		init?(defaultType: TypeSyntax, binding: PatternBindingSyntax, argument: MemberAttributeArgument?) throws {
			sourceType = binding.typeAnnotation?.type.trimmed ?? defaultType

			self.type = if let optionalType = sourceType.as(OptionalTypeSyntax.self) {
				optionalType.wrappedType.trimmed
			} else if let implicitlyUnwrappedOptional = sourceType.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
				implicitlyUnwrappedOptional.wrappedType.trimmed
			} else {
				sourceType
			}
			self.optionalType = OptionalTypeSyntax(wrappedType: type)

			switch argument {
				case let .customKey(customKey):
					customCodingKey = customKey
				case .serialization(.unserialized):
					return nil
				default:
					customCodingKey = nil
			}

			guard let bindingPattern = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
				throw Diagnostic.invalidBindingPattern
			}
			name = bindingPattern

			optionalSerializationFlags = OptionalSerializationFlags(binding: binding, type: sourceType)
		}
	}
}
