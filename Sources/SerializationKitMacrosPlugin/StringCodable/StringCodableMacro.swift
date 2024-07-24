import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum StringCodableMacro: ExtensionMacro {
	public static func expansion(
		of node: AttributeSyntax,
		attachedTo declaration: some DeclGroupSyntax,
		providingExtensionsOf type: some TypeSyntaxProtocol,
		conformingTo protocols: [TypeSyntax],
		in context: some MacroExpansionContext
	) throws -> [ExtensionDeclSyntax] {
		let enumDeclaration = try unwrapEnumDeclaration(declaration)
		try validatePrimaryType(declaration: enumDeclaration)
		let memberItemIdentifiers = try retrieveMembersItemIdentifiers(declaration: enumDeclaration)

		return try [
			buildExtensionBlock(type: type, cases: memberItemIdentifiers),
		]
	}
}

// MARK: - Syntax Processing

private extension StringCodableMacro {
	static func unwrapEnumDeclaration(_ declaration: some DeclGroupSyntax) throws -> EnumDeclSyntax {
		guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
			throw Diagnostic.enumOnly
		}
		return enumDecl
	}

	static func validatePrimaryType(declaration: EnumDeclSyntax) throws {
		guard
			let primaryType = declaration.inheritanceClause?.inheritedTypes.first?.type.as(IdentifierTypeSyntax.self)?.name.tokenKind,
			validPrimaryTypes.contains(primaryType)
		else {
			throw Diagnostic.requiresPrimaryNumericType
		}
	}

	static func retrieveMembersItemIdentifiers(declaration: EnumDeclSyntax) throws -> [TokenSyntax] {
		let memberItemIdentifiers = declaration.memberBlock.members.compactMap { memberItem in
			memberItem.decl.as(EnumCaseDeclSyntax.self)
		}
		.flatMap { memberItem in
			memberItem.elements.map(\.name)
		}
		guard !memberItemIdentifiers.isEmpty else {
			throw Diagnostic.notEmpty
		}

		return memberItemIdentifiers
	}
}

// MARK: - String Builder

private extension StringCodableMacro {
	static func buildCodingValuesEnum(_ cases: [TokenSyntax]) throws -> EnumDeclSyntax {
		try EnumDeclSyntax(#"private enum __CodingValues: String, Codable"#) {
			for item in cases {
				"    case \(item)"
			}
		}
	}

	static func buildDecoderBlock(_ cases: [TokenSyntax]) throws -> InitializerDeclSyntax {
		try InitializerDeclSyntax(#"public init(from decoder: any Decoder) throws"#) {
			"""
			    let container = try decoder.singleValueContainer()
			        let codingValue: __CodingValues = try container.decode(__CodingValues.self)
			        self = switch codingValue {
			\(raw: cases.map { item in "            case __CodingValues.\(item.text): Self.\(item.text)" }.joined(separator: "\n"))
			        }
			"""
		}
	}

	static func buildEncoderBlock(_ cases: [TokenSyntax]) throws -> FunctionDeclSyntax {
		try FunctionDeclSyntax("public func encode(to encoder: any Encoder) throws") {
			"""
			    var container = encoder.singleValueContainer()
			        let codingValue: __CodingValues = switch self {
			\(raw: cases.map { item in "            case Self.\(item): __CodingValues.\(item)" }.joined(separator: "\n"))
			        }
			        try container.encode(codingValue)
			"""
		}
	}

	static func buildExtensionBlock(type: some TypeSyntaxProtocol, cases: [TokenSyntax]) throws -> ExtensionDeclSyntax {
		try ExtensionDeclSyntax("extension \(type.trimmed): Codable") {
			try buildCodingValuesEnum(cases)
			try buildDecoderBlock(cases)
			try buildEncoderBlock(cases)
		}
	}
}

// MARK: - Constants

private extension StringCodableMacro {
	static let validPrimaryTypes: [TokenKind] = [
		TokenKind.identifier("Float"),
		TokenKind.identifier("Double"),
		TokenKind.identifier("Int8"),
		TokenKind.identifier("Int16"),
		TokenKind.identifier("Int32"),
		TokenKind.identifier("Int64"),
		TokenKind.identifier("Int"),
		TokenKind.identifier("UInt8"),
		TokenKind.identifier("UInt16"),
		TokenKind.identifier("UInt32"),
		TokenKind.identifier("UInt64"),
		TokenKind.identifier("UInt"),
	]
}
