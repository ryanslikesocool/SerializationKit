import Foundation

public struct CodablePayload<Base: CodableMetatypeAccessor>: Codable {
	public private(set) var base: Base
	public private(set) var payload: any Codable

	private enum CodingKeys: Int, CodingKey {
		case base
		case payload
	}

	public init(_ payload: any Codable, base: Base) {
		self.payload = payload
		self.base = base
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		base = try container.decode(Base.self, forKey: .base)
		payload = try container.decode(base.codableMetatype, forKey: .payload)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(base, forKey: .base)
		try container.encode(payload, forKey: .payload)
	}
}
