import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension CodableMacro: ExtensionMacro {
	public static func expansion(
		of node: AttributeSyntax,
		attachedTo declaration: some DeclGroupSyntax,
		providingExtensionsOf type: some TypeSyntaxProtocol,
		conformingTo protocols: [TypeSyntax],
		in context: some MacroExpansionContext
	) throws -> [ExtensionDeclSyntax] {
		/// Cannot use `lazy var` here.  Increases build time substantially (like possibly forever).
		let arguments: [AttributeArgument] = try getAttributeArguments(declaration) ?? []

		return switch declaration.kind {
			case .classDecl, .structDecl: try processClassStructDeclaration(type: type, declaration: declaration, arguments: arguments)
			case .enumDecl: try processEnumDeclaration(type: type, declaration: declaration, arguments: arguments)
			default: throw Diagnostic.invalidAttributeContext
		}
	}
}
