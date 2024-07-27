import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum CodableMacro { }

// MARK: - Constants

extension CodableMacro {
	static let macroAttributeName: TokenKind = .identifier("Codable")
}

// MARK: - Common

extension CodableMacro {
	static func unwrapBindings(in declaration: borrowing VariableDeclSyntax) throws -> [(PatternBindingSyntax, TypeSyntax)] {
		let reversedBindings = declaration.bindings.reversed()
		guard var currentType = reversedBindings.first?.typeAnnotation?.type else {
			throw Diagnostic.requiresExplicitTypeAnnotation
		}

		return reversedBindings.map { binding -> (PatternBindingSyntax, TypeSyntax) in
			if let newType = binding.typeAnnotation?.type {
				currentType = newType
			}

			return (binding, currentType)
		}
		.reversed()
	}

	static func validateBindings(_ bindings: borrowing PatternBindingListSyntax, arguments: borrowing [AttributeArgument]) throws {
		if
			bindings.count == 1,
			let binding = bindings.last
		{
			try validateSingleBinding(binding, arguments: arguments)
		} else {
			try validateMultipleBindings(bindings, arguments: arguments)
		}
	}

	static func getAttributeArguments(_ declaration: borrowing some DeclSyntaxProtocol) throws -> [AttributeArgument]? {
		try retrieveCodableAttribute(declaration)?
			.arguments?
			.as(LabeledExprListSyntax.self)?
			.map { argument in
				try unwrapAttributeArgument(argument.expression)
			}
	}

	static func getEnumCases(_ declaration: borrowing EnumDeclSyntax) -> [EnumCaseElementSyntax] {
		declaration.memberBlock
			.members
			.compactMap { member in member.decl.as(EnumCaseDeclSyntax.self) }
			.flatMap { enumCase in enumCase.elements }
	}
}

// MARK: - Private

private extension CodableMacro {
	static func isSomeOptionalType(_ type: TypeSyntax?) -> Bool? {
		guard let type else {
			return nil
		}
		return isSomeOptionalType(type)
	}

	static func isSomeOptionalType(_ type: borrowing TypeSyntax) -> Bool {
		type.is(OptionalTypeSyntax.self) || type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self)
	}

	static func retrieveCodableAttribute(_ declaration: some DeclSyntaxProtocol) throws -> AttributeSyntax? {
		let attributes: AttributeListSyntax? = switch declaration.kind {
			case .classDecl: declaration.as(ClassDeclSyntax.self)?.attributes
			case .structDecl: declaration.as(StructDeclSyntax.self)?.attributes
			case .enumDecl: declaration.as(EnumDeclSyntax.self)?.attributes
			case .variableDecl: declaration.as(VariableDeclSyntax.self)?.attributes
			default:
				throw Diagnostic.invalidAttributeContext
		}
		guard let attributes else {
			return nil
		}

		let validAttributes: [AttributeSyntax] = attributes
			.compactMap { attribute in attribute.as(AttributeSyntax.self) }
			.filter { attribute in attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.tokenKind == macroAttributeName }

		guard validAttributes.count < 2 else {
			throw Diagnostic.onlyOneAttribute
		}

		return validAttributes.first
	}

	static func unwrapAttributeArgument(_ expression: borrowing ExprSyntax) throws -> AttributeArgument {
		if
			let memberAccess = expression.as(MemberAccessExprSyntax.self),
			let token = memberAccess.lastToken(viewMode: .fixedUp)?.tokenKind
		{
			if let objectContainer = CodableObjectContainer(token) {
				AttributeArgument.objectContainer(objectContainer)
			} else if let enumSerialization = CodableEnumSerialization(token) {
				AttributeArgument.enumSerialization(enumSerialization)
			} else if let propertySerialization = CodablePropertySerialization(token) {
				AttributeArgument.propertySerialization(propertySerialization)
			} else if let sequenceSerialization = CodableSequenceSerialization(token) {
				AttributeArgument.sequenceSerialization(sequenceSerialization)
			} else {
				throw Diagnostic.invalidAttributeArgument
			}
		} else if let stringLiteral = expression.as(StringLiteralExprSyntax.self) {
			if
				stringLiteral.segments.count == 1,
				let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
			{
				AttributeArgument.propertyCustomKey(segment.content)
			} else {
				throw Diagnostic.staticStringLiteral
			}
		} else {
			throw Diagnostic.invalidAttributeArgument
		}
	}
}

// MARK: - Validation

private extension CodableMacro {
	static func validateSingleBinding(_ binding: borrowing PatternBindingSyntax, arguments: some Sequence<AttributeArgument>) throws {
		guard let typeAnnotation = binding.typeAnnotation else {
			throw Diagnostic.requiresExplicitTypeAnnotation
		}

		for argument in arguments {
			try validate(argument: argument)
		}

		func validate(argument: AttributeArgument) throws {
			if
				case .propertySerialization(.unserialized) = argument,
				!isSomeOptionalType(typeAnnotation.type),
				binding.initializer == nil
			{
				throw Diagnostic.unserializedRequiresDefault
			}
		}
	}

	static func validateMultipleBindings(_ bindings: borrowing PatternBindingListSyntax, arguments: some Sequence<AttributeArgument>) throws {
		for argument in arguments {
			try validate(argument: argument)
		}

		func validate(argument: AttributeArgument) throws {
			switch argument {
				case .propertyCustomKey:
					throw Diagnostic.customKeySingleBinding
				case .propertySerialization(.unserialized):
					if
						bindings.contains(where: { binding in isSomeOptionalType(binding.typeAnnotation?.type) == false }),
						bindings.contains(where: { binding in binding.initializer == nil })
					{
						throw Diagnostic.unserializedRequiresDefault
					}
				default:
					break
			}
		}
	}
}
