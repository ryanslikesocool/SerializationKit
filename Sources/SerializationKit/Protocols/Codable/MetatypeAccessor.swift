import Foundation

/// Provides access to a metatype for use with ``CodablePayload``.
public protocol CodableMetatypeAccessor: Codable {
	var codableMetatype: any Codable.Type { get }
}
