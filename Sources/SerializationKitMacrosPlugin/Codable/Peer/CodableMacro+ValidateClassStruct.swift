import SwiftSyntax

extension CodableMacro {
	static func validateClassStructDeclaration(_ declaration: borrowing some DeclSyntaxProtocol, arguments: borrowing [AttributeArgument]) throws {
		try validateArguments(arguments)
	}
}

private extension CodableMacro {
	static func validateArguments(_ arguments: [AttributeArgument]) throws {
		var occupiedArguments: AllowedArguments = .none

		for argument in arguments {
			try validate(argument)
		}

		func validate(_ argument: AttributeArgument) throws {
			let insertingArgument: AllowedArguments = switch argument {
				case .objectContainer: .objectContainer
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
		static let objectContainer: Self = Self(rawValue: 1 << 0)
	}
}
