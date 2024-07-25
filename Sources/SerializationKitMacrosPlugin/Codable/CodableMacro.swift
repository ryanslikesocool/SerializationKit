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
	static func getMemberAttribute(_ declaration: VariableDeclSyntax) throws -> MemberAttributeArgument? {
		guard
			let attribute = try retrieveCodableAttribute(declaration),
			let arguments = attribute.arguments?.as(LabeledExprListSyntax.self),
			let argument = arguments.first
		else {
			return nil
		}

		return try processMemberAttributeArguments(expression: argument.expression)
	}

	static func unwrapBindings(in declaration: borrowing VariableDeclSyntax) throws -> [(PatternBindingSyntax, TypeSyntax)] {
		let reversedBindings = declaration.bindings.reversed()
		guard var currentType = reversedBindings.last?.typeAnnotation?.type else {
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

	static func validateBindings(_ bindings: PatternBindingListSyntax, argument: MemberAttributeArgument?) throws {
		if 
			bindings.count == 1,
			let binding = bindings.first
		{
			guard let typeAnnotation = binding.typeAnnotation else {
				throw Diagnostic.requiresExplicitTypeAnnotation
			}

			if
				case .serialization(.unserialized) = argument,
				!isSomeOptionalType(typeAnnotation.type),
				binding.initializer == nil
			{
				throw Diagnostic.unserializedRequiresDefault
			}
		} else {
			switch argument {
				case .customKey:
					throw Diagnostic.customKeySingleBinding
				case .serialization(.unserialized):
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

// MARK: - Private

private extension CodableMacro {
	static func isSomeOptionalType(_ type: TypeSyntax?) -> Bool? {
		guard let type else {
			return nil
		}
		return isSomeOptionalType(type)
	}

	static func isSomeOptionalType(_ type: TypeSyntax) -> Bool {
		type.is(OptionalTypeSyntax.self) || type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self)
	}

	static func retrieveCodableAttribute(_ declaration: VariableDeclSyntax) throws -> AttributeSyntax? {
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
			let serializationMode = CodablePropertySerialization(token)
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
