import Foundation

public extension SingleValueEncodingContainer {
	mutating func encode<T, U>(_ value: U, using metatype: T.Type) throws where
		T: CodableMetatypeAccessor,
		U: Codable
	{
		let valueType = type(of: value)
		guard let base = T.allCases.first(where: { metatype in metatype.encodableMetatype == valueType }) else {
			print("Failed to find a valid metatype in \(T.self) for the given value \(value)")
			return
		}
		try encode(CodablePayload<T>(value, base: base))
	}
}
