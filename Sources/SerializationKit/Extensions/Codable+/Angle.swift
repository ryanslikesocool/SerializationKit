#if canImport(SwiftUI)
import SwiftUI

extension Angle: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.init(radians: try container.decode(Double.self))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(radians)
	}
}
#endif
