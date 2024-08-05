import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CodableMacro {
	static func processEnumDeclaration(type: some TypeSyntaxProtocol, declaration: some DeclGroupSyntax, arguments: [AttributeArgument]) throws -> [ExtensionDeclSyntax] {
		let enumDeclaration = try processObjectDeclaration(declaration)
		let cases = getEnumCases(enumDeclaration).map { enumCase in
			enumCase.name
		}
		let enumSerialization = try processArguments(arguments)

		return try [
			buildExtensionBlock(type: type, cases: cases, enumSerialization: enumSerialization),
		]
	}
}

// MARK: - Syntax Processing

private extension CodableMacro {
	static func processObjectDeclaration(_ declaration: some DeclGroupSyntax) throws -> EnumDeclSyntax {
		guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
			throw Diagnostic.enumOnly
		}
		return enumDecl
	}

	static func processArguments(_ arguments: [AttributeArgument]) throws  -> CodableEnumSerialization {
		var enumSerialization: CodableEnumSerialization? = nil

		for argument in arguments {
			if case let .enumSerialization(serialization) = argument {
				enumSerialization = serialization
				break
			}
		}

		guard let enumSerialization else {
			throw Diagnostic.missingEnumSerialization
		}
		return enumSerialization
	}
}

// MARK: - String Builder

private extension CodableMacro {
	static func buildCodingValuesEnum(_ cases: [TokenSyntax], enumSerialization: CodableEnumSerialization) throws -> EnumDeclSyntax {
		let declaration: SyntaxNodeString = switch enumSerialization {
			case .asString: "private enum __CodingValues: String, Codable"
			case .asInteger: "private enum __CodingValues: Int, Codable"
		}

		return try EnumDeclSyntax(declaration) {
			for item in cases {
				"    case \(item)"
			}
		}
	}

	static func buildDecoderBlock(_ cases: [TokenSyntax]) throws -> InitializerDeclSyntax {
		let switchContent: String = cases.map { item in
			"            case __CodingValues.\(item.text): Self.\(item.text)"
		}.joined(separator: "\n")

		return try InitializerDeclSyntax("public init(from decoder: any Decoder) throws") {
			"""
			    let container = try decoder.singleValueContainer()
			        let codingValue: __CodingValues = try container.decode(__CodingValues.self)
			        self = switch codingValue {
			\(raw: switchContent)
			        }
			"""
		}
	}

	static func buildEncoderBlock(_ cases: [TokenSyntax]) throws -> FunctionDeclSyntax {
		let switchContent: String = cases.map { item in
			"            case Self.\(item): __CodingValues.\(item)"
		}.joined(separator: "\n")

		return try FunctionDeclSyntax("public func encode(to encoder: any Encoder) throws") {
			"""
			    var container = encoder.singleValueContainer()
			        let codingValue: __CodingValues = switch self {
			\(raw: switchContent)
			        }
			        try container.encode(codingValue)
			"""
		}
	}

	static func buildExtensionBlock(type: some TypeSyntaxProtocol, cases: [TokenSyntax], enumSerialization: CodableEnumSerialization) throws -> ExtensionDeclSyntax {
		try ExtensionDeclSyntax("extension \(type.trimmed): Codable") {
			try buildCodingValuesEnum(cases, enumSerialization: enumSerialization)
			try buildDecoderBlock(cases)
			try buildEncoderBlock(cases)
		}
	}
}
