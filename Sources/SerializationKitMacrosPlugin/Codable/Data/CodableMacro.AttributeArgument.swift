import SwiftSyntax

extension CodableMacro {
	enum AttributeArgument {
		case objectContainer(CodableObjectContainer)
		case enumSerialization(CodableEnumSerialization)
		
		case collectionSerialization(CodableCollectionSerialization)
		case propertySerialization(CodablePropertySerialization)
		case propertyCustomKey(TokenSyntax)
	}
}
