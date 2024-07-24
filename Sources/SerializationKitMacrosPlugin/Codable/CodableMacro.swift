import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum CodableMacro { }

// MARK: - Constants

extension CodableMacro {
	static let macroAttributeName: TokenKind = .identifier("Codable")
}

// MARK: - Supporting Data

extension CodableMacro {
	enum MemberAttributeArgument {
		case serialization(CodablePropertySerialization)
		case customKey(TokenSyntax)
	}
}

// MARK: - Common

extension CodableMacro {
	@discardableResult
	static func validateMember(_ declaration: some DeclSyntaxProtocol) throws -> VariableDeclSyntax {
		guard
			let variableDeclaration = declaration.as(VariableDeclSyntax.self),
			!variableDeclaration.bindings.contains(where: { binding in binding.accessorBlock != nil })
		else {
			throw Diagnostic.storedPropertiesOnly
		}
		return variableDeclaration
	}

	static func validateMemberAttribute(_ declaration: VariableDeclSyntax) throws -> MemberAttributeArgument? {
		guard
			let attribute = try processAttributes(declaration),
			let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
			let argument = arguments.first
		else {
			return nil
		}

		return try processMemberAttributeArguments(expression: argument.expression)
	}

	@discardableResult
	static func validateBindings(in declaration: VariableDeclSyntax, argument: MemberAttributeArgument?) throws -> TypeSyntax {
		switch argument {
			case .customKey
			where declaration.bindings.count != 1:
				throw Diagnostic.customKeySingleBinding
			default:
				break
		}

		guard let lastBindingType = declaration.bindings.last?.typeAnnotation?.type else {
			throw Diagnostic.requiresExplicitAnnotation
		}

		if
			case .serialization(.unserialized) = argument,
			!isAnyOptionalType(lastBindingType),
			declaration.bindings.contains(where: { binding in binding.initializer == nil })
		{
			throw Diagnostic.unserializedRequiresDefault
		}

		return lastBindingType.trimmed
	}
}

// MARK: - Private

private extension CodableMacro {
	static func isAnyOptionalType(_ type: TypeSyntax) -> Bool {
		type.is(OptionalTypeSyntax.self) || type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self)
	}

	static func processAttributes(_ declaration: VariableDeclSyntax) throws -> AttributeSyntax? {
		let validAttributes: [AttributeSyntax] = declaration.attributes
			.compactMap { attribute in attribute.as(AttributeSyntax.self) }
			.filter { attribute in attribute.attributeName.as(IdentifierTypeSyntax.self)?.name.tokenKind == macroAttributeName }

		guard validAttributes.count < 2 else {
			throw Diagnostic.onlyOneAttribute
		}

		return validAttributes.first
	}

	static func processMemberAttributeArguments(expression: ExprSyntax) throws -> MemberAttributeArgument? {
		if
			let memberAccess = expression.as(MemberAccessExprSyntax.self),
			let token = memberAccess.lastToken(viewMode: .fixedUp)?.tokenKind,
			let serializationMode = CodablePropertySerialization.associatedTokens[token]
		{
			return MemberAttributeArgument.serialization(serializationMode)
		} else if let stringLiteral = expression.as(StringLiteralExprSyntax.self) {
			guard
				stringLiteral.segments.count == 1,
				let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
			else {
				throw Diagnostic.staticStringLiteral
			}
			return MemberAttributeArgument.customKey(segment.content)
		}

		return nil
	}
}
