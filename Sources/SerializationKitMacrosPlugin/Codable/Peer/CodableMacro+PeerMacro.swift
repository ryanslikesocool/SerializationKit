import SwiftCompilerPluginMessageHandling
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension CodableMacro: PeerMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingPeersOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		/// Cannot use `lazy var` here.  Increases build time substantially (like possibly forever).
		let arguments: [AttributeArgument] = try getAttributeArguments(declaration) ?? []

		switch declaration.kind {
			case .classDecl, .structDecl:
				try validateClassStructDeclaration(declaration, arguments: arguments)
			case .enumDecl:
				try validateEnumDeclaration(declaration, arguments: arguments)
			case .variableDecl:
				try validateVariableDeclaration(declaration, arguments: arguments)
			default:
				throw Diagnostic.invalidAttributeContext
		}

		// validation only.  do not generate any code.
		return []
	}
}
