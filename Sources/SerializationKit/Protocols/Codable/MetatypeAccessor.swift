// MARK: - DecodableMetatypeAccessor

public protocol DecodableMetatypeAccessor: Decodable, CaseIterable {
	var decodableMetatype: any Decodable.Type { get }
}

// MARK: - EncodableMetatypeAccessor

public protocol EncodableMetatypeAccessor: Encodable, CaseIterable {
	var encodableMetatype: any Encodable.Type { get }
}

// MARK: - CodableMetatypeAccessor

public protocol CodableMetatypeAccessor: DecodableMetatypeAccessor, EncodableMetatypeAccessor {
	var codableMetatype: any Codable.Type { get }
}

// MARK: - Default Implenentation

public extension CodableMetatypeAccessor {
	var decodableMetatype: Decodable.Type { codableMetatype }
	var encodableMetatype: Encodable.Type { codableMetatype }
}
