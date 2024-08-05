import SwiftSyntax

extension CodableMacro {
	static func validateVariableDeclaration(_ declaration: borrowing some DeclSyntaxProtocol, arguments: borrowing [AttributeArgument]) throws {
		let declaration: VariableDeclSyntax = try assertIsStoredVariable(declaration)
		try assertTypeAnnotation(declaration)
		try assertSingleBindingOrNoInitializer(declaration)
	}
}

private extension CodableMacro {
	static func assertIsStoredVariable(_ declaration: borrowing some DeclSyntaxProtocol) throws -> VariableDeclSyntax {
		guard
			let variableDeclaration = declaration.as(VariableDeclSyntax.self),
			!variableDeclaration.bindings.contains(where: { binding in binding.accessorBlock != nil })
		else {
			throw Diagnostic.storedPropertiesOnly
		}

		return variableDeclaration
	}

	static func assertTypeAnnotation(_ declaration: borrowing VariableDeclSyntax) throws {
		guard declaration.bindings.last?.typeAnnotation != nil else {
			throw Diagnostic.requiresExplicitTypeAnnotation
		}
	}

	static func assertSingleBindingOrNoInitializer(_ declaration: borrowing VariableDeclSyntax) throws {
		if
			declaration.bindings.count != 1,
			declaration.bindings.contains(where: { binding in
				binding.initializer != nil
			})
		{
			throw Diagnostic.singleBindingOrNoInitializer
		}
	}

	static func validateArguments(_ arguments: [AttributeArgument]) throws {
		var occupiedArguments: AllowedArguments = .none

		for argument in arguments {
			try validate(argument)
		}

		func validate(_ argument: AttributeArgument) throws {
			let insertingArgument: AllowedArguments = switch argument {
				case .propertySerialization: .propertySerialization
				case .collectionSerialization: .collectionSerialization
				case .propertyCustomKey: .propertyCustomKey
				default: throw Diagnostic.invalidAttributeArgument
			}

			if !occupiedArguments.insert(insertingArgument).inserted {
				throw Diagnostic.duplicateArgument
			}
		}
	}
}

// MARK: - Supporting Data

private extension CodableMacro {
	struct AllowedArguments: OptionSet {
		let rawValue: UInt8

		static let none: Self = Self(rawValue: 0)
		static let propertySerialization: Self = Self(rawValue: 1 << 0)
		static let collectionSerialization: Self = Self(rawValue: 1 << 1)
		static let propertyCustomKey: Self = Self(rawValue: 1 << 2)
	}
}
