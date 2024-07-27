import SwiftSyntax

extension CodableMacro {
	enum AttributeArgument {
		case objectContainer(CodableObjectContainer)
		case enumSerialization(CodableEnumSerialization)
		
		case sequenceSerialization(CodableSequenceSerialization)
		case propertySerialization(CodablePropertySerialization)
		case propertyCustomKey(TokenSyntax)
	}
}
