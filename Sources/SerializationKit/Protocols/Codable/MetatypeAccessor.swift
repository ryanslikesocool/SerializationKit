/// Provides access to a metatype for use with ``CodablePayload``.
public protocol CodableMetatypeAccessor: Codable, CaseIterable {
	var codableMetatype: any Codable.Type { get }
}
