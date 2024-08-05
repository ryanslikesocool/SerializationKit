@testable import SerializationKit
import XCTest

final class CodablePayloadTests: XCTestCase {
	func testCodablePayloadEncoding() throws {
		try CodableUtility.assertEncoding(
			TestPayload(Float(0.555)),
			expected: """
			{
			  "value" : {
			    "base" : "float",
			    "payload" : 0.555
			  }
			}
			"""
		)
	}

	func testCodablePayloadDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : {
				"base" : "bool",
				"payload" : true
			  }
			}
			""", expected: TestPayload(true)
		)
	}

	func testCodablePayloadRoundTrip() throws {
		let string: String = """
		{
		  "value" : {
		    "base" : "float3",
		    "payload" : [
		      0.5,
		      0.7,
		      0.3
		    ]
		  }
		}
		"""
		let payload: TestPayload = TestPayload(SIMD3<Float>(0.5, 0.7, 0.3))

		try CodableUtility.assertEncoding(payload, expected: string)
		try CodableUtility.assertDecoding(string, expected: payload)
	}
}

// MARK: - Supporting Data

private struct TestPayload: Hashable, Codable {
	let value: any TestPayloadValue

	init(_ value: some TestPayloadValue) {
		self.value = value
	}

	private enum CodingKeys: CodingKey {
		case value
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		value = try container.decode(using: TestMetatype.self, as: (any TestPayloadValue).self, forKey: .value)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(value, using: TestMetatype.self, forKey: .value)
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}

	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
}

private enum TestMetatype: String, CodableMetatypeAccessor {
	case bool
	case float
	case float2
	case float3
	case float4
	case int
	case string

	init?(from value: some TestPayloadValue) {
		switch value {
			case _ as Bool: self = .bool
			case _ as Float: self = .float
			case _ as SIMD2<Float>: self = .float2
			case _ as SIMD3<Float>: self = .float3
			case _ as SIMD4<Float>: self = .float4
			case _ as Int: self = .int
			case _ as String: self = .string
			default: return nil
		}
	}

	var codableMetatype: Codable.Type {
		switch self {
			case .bool: Bool.self
			case .float: Float.self
			case .float2: SIMD2<Float>.self
			case .float3: SIMD3<Float>.self
			case .float4: SIMD4<Float>.self
			case .int: Int.self
			case .string: String.self
		}
	}
}

private protocol TestPayloadValue: Hashable, Codable { }

extension Bool: TestPayloadValue { }
extension Float: TestPayloadValue { }
extension SIMD2<Float>: TestPayloadValue { }
extension SIMD3<Float>: TestPayloadValue { }
extension SIMD4<Float>: TestPayloadValue { }
extension Int: TestPayloadValue { }
extension String: TestPayloadValue { }
