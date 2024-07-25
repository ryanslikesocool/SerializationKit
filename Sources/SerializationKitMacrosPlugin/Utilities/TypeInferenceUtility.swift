import SwiftSyntax

public enum TypeInferenceUtility {
	static func infer(from expression: borrowing ExprSyntax) -> TypeSyntax? {
		switch expression.kind {
			case .booleanLiteralExpr: self.bool
			case .integerLiteralExpr: self.int
			case .floatLiteralExpr: self.double
			case .stringLiteralExpr: self.string
			default:
//				if let array = expression.as(ArrayExprSyntax.self) {
////					infer(from: array)
//					// TODO: implement
//					nil
//				} else if let dictionary = expression.as(DictionaryExprSyntax.self) {
////					infer(from: dictionary)
//					// TODO: implement
//					nil
//				} else if let memberAccess = expression.as(MemberAccessExprSyntax.self) {
////					infer(from: memberAccess)
//					// TODO: implement
//					nil
//				} else {
//					nil
//				}
				nil
		}

	}

//	static func infer(from expression: ArrayExprSyntax) -> TypeSyntax? {
//		var discardedElementBestGuesses: (TypeSyntax, TypeSyntax)?
//		var elementBestGuess: TypeSyntax?
//
//		for element in expression.elements {
//			guard let elementGuess: TypeSyntax = infer(from: element.expression) else {
//				continue
//			}
//
//			switch (elementBestGuess, discardedElementBestGuesses) {
//				case (.none, .none): elementBestGuess = elementGuess
//				case let (.some(elementBestGuess), .none):
//					if elementBestGuess == elementGuess {
//						continue
//					} else {
//						discardedElementBestGuesses = (elementBestGuess, elementGuess)
//					}
//				case let (.none,)
//			}
//		}
//
//		guard let element = elementBestGuess else {
//			return nil
//		}
//		let arrayType = ArrayTypeSyntax(element: elementBestGuess)
////		return ExprSyntax()
//	}
//
//	static func infer(from expression: DictionaryExprSyntax) -> TypeSyntax? {
//		var keyBestGuess: TypeSyntax?
//		var valueBestGuess: TypeSyntax?
//
//
//		guard
//			let keyBestGuess,
//			let valueBestGuess
//		else {
//			return nil
//		}
//
//	}

//	static func infer(from expression: MemberAccessExprSyntax) -> TypeSyntax? {
//		guard let base = expression.base else {
//			return nil
//		}
//
//		if case let .identifier(text) =  base.as(DeclReferenceExprSyntax.self)?.baseName.tokenKind {
//
//		} else if let generic = base.as(GenericSpecializationExprSyntax.self) {
//			generic.
//		}
//		switch base.kind {
//			case .identifierType:
//			case .genericSpecializationExpr:
//		}
//	}
}

private extension TypeInferenceUtility {
	static let bool = TypeSyntax(IdentifierTypeSyntax(name: "Bool"))
	static let int = TypeSyntax(IdentifierTypeSyntax(name: "Int"))
	static let double = TypeSyntax(IdentifierTypeSyntax(name: "Double"))
	static let string = TypeSyntax(IdentifierTypeSyntax(name: "String"))
}
