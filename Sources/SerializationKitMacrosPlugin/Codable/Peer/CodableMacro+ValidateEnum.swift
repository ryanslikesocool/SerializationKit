import SwiftSyntax

extension CodableMacro {
	static func validateEnumDeclaration(_ declaration: borrowing some DeclSyntaxProtocol, arguments: borrowing [AttributeArgument]) throws {
		let enumDeclaration: EnumDeclSyntax = try assertIsEnum(declaration)

		try validateArguments(arguments)

		let cases = getEnumCases(enumDeclaration)
		try assertHasCases(cases)
		try assertNoAssociatedValues(cases)
	}
}

private extension CodableMacro {
	static func assertIsEnum(_ declaration: some DeclSyntaxProtocol) throws -> EnumDeclSyntax {
		guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
			throw Diagnostic.enumOnly
		}
		return enumDeclaration
	}

	static func validateArguments(_ arguments: [AttributeArgument]) throws {
		var occupiedArguments: AllowedArguments = .none

		for argument in arguments {
			try validate(argument)
		}

		func validate(_ argument: AttributeArgument) throws {
			let insertingArgument: AllowedArguments = switch argument {
				case .enumSerialization: .enumSerialization
				default: throw Diagnostic.invalidAttributeArgument
			}

			if !occupiedArguments.insert(insertingArgument).inserted {
				throw Diagnostic.duplicateArgument
			}
		}
	}

	static func assertHasCases(_ cases: [EnumCaseElementSyntax]) throws {
		guard !cases.isEmpty else {
			throw Diagnostic.enumNotEmpty
		}
	}

	static func assertNoAssociatedValues(_ cases: [EnumCaseElementSyntax]) throws {
		guard !cases.contains(where: { enumCase in
			enumCase.parameterClause != nil
		}) else {
			throw Diagnostic.noEnumAssociatedValues
		}
	}
}

// MARK: - Supporting Data

private extension CodableMacro {
	struct AllowedArguments: OptionSet {
		let rawValue: UInt8

		static let none: Self = Self(rawValue: 0)
		static let enumSerialization: Self = Self(rawValue: 1 << 0)
	}
}
