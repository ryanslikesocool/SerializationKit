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
		guard
			!declaration.is(ClassDeclSyntax.self),
			!declaration.is(StructDeclSyntax.self)
		else {
			return []
		}

		let declaration: VariableDeclSyntax = try assertMemberIsStoredVariable(declaration)
		try assertTypeAnnotation(declaration)
		try assertSingleBindingOrNoInitializer(declaration)

		// validation only.  do not generate any code.
		return []
	}
}

// MARK: - Syntax Processing

private extension CodableMacro {
	static func assertMemberIsStoredVariable(_ declaration: some DeclSyntaxProtocol) throws -> VariableDeclSyntax {
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
}
