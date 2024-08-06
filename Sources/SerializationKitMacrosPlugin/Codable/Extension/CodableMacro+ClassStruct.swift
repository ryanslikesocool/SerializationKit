import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CodableMacro {
	static func processClassStructDeclaration(type: some TypeSyntaxProtocol, declaration: some DeclGroupSyntax, arguments: [AttributeArgument]) throws -> [ExtensionDeclSyntax] {
		try validateObjectDeclaration(declaration)
		let bindings: [BindingData] = try retrieveBindings(in: declaration)
		let container: CodableObjectContainer = try retrieveContainerType(arguments, from: bindings)

		return try [
			buildExtensionBlock(type: type, bindings: bindings, container: container),
		]
	}
}

// MARK: - Syntax Processing

private extension CodableMacro {
	static func validateObjectDeclaration(_ declaration: some DeclGroupSyntax) throws {
		guard
			declaration.is(ClassDeclSyntax.self)
			|| declaration.is(StructDeclSyntax.self)
		else {
			throw Diagnostic.classOrStructOnly
		}
	}

	static func findViableMembers(in declaration: some DeclGroupSyntax) throws -> [VariableDeclSyntax] {
		declaration.memberBlock.members
			.compactMap { member in member.decl.as(VariableDeclSyntax.self) }
			.filter { member in
				!member.bindings.contains(where: { binding in  binding.accessorBlock != nil })
				&& !member.modifiers.contains(where: { modifier in modifier.name.tokenKind == .keyword(.static) })
			}
	}

	static func retrieveBindings(in declaration: some DeclGroupSyntax) throws -> [BindingData] {
		try findViableMembers(in: declaration)
			.flatMap(createBindingData)
	}

	static func createBindingData(for declaration: VariableDeclSyntax) throws -> [BindingData] {
		let propertyArguments = try getAttributeArguments(declaration) ?? []
		try validateBindings(declaration.bindings, arguments: propertyArguments)
		let bindings: [(PatternBindingSyntax, TypeSyntax)] = try unwrapBindings(in: declaration)

		return try bindings.compactMap { binding, type in
			try BindingData(defaultType: type, binding: binding, arguments: propertyArguments)
		}
	}

	static func retrieveContainerType(_ arguments: [AttributeArgument], from bindings: [BindingData]) throws -> CodableObjectContainer {
		for argument in arguments {
			if case let .objectContainer(container) = argument {
				return container
			}
		}

		return retrieveDefaultContainerType(from: bindings)
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
		let declaration: SyntaxNodeString = if bindings.contains(where: { binding in binding.customCodingKey != nil }) {
			"private enum __CodingKeys: String, CodingKey"
		} else {
			"private enum __CodingKeys: CodingKey"
		}

		return try EnumDeclSyntax(declaration) {
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
