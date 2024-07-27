@testable import SerializationKit
import XCTest

final class CodableMacroTests: XCTestCase {
	func testKeyedEncoding() throws {
		try CodableUtility.assertEncoding(
			TestKeyedPayload(valueB: Float.zero, valueD: false, valueF: "Hello, world!"),
			expected: """
			{
			  "firstValue" : 0,
			  "secondValue" : 16,
			  "valueC" : 2,
			  "valueD" : false,
			  "valueF" : "Hello, world!"
			}
			"""
		)
	}

	func testKeyedDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "firstValue" : 0,
			  "secondValue" : 16,
			  "valueC" : 2,
			  "valueD" : false,
			  "valueF" : "Hello, world!"
			}
			""",
			expected: TestKeyedPayload(valueB: Float.zero, valueD: false, valueF: "Hello, world!")
		)
	}

	func testSingleValueEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestSingleValuePayload(rawValue: 12)),
			expected: """
			{
			  "value" : 12
			}
			"""
		)
	}

	func testSingleValueDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 12
			}
			""",
			expected: PayloadWrapper(value: TestSingleValuePayload(rawValue: 12))
		)
	}

	func testSingleValueOptionalEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestSingleValueOptionalPayload(rawValue: nil)),
			expected: """
			{
			  "value" : null
			}
			"""
		)
	}

	func testSingleValueOptionalAlternateEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestSingleValueOptionalPayload(rawValue: 32)),
			expected: """
			{
			  "value" : 32
			}
			"""
		)
	}

	func testSingleValueOptionalDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : null
			}
			""",
			expected: PayloadWrapper(value: TestSingleValueOptionalPayload(rawValue: nil))
		)
	}

	func testSingleValueOptionalAlternateDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 32
			}
			""",
			expected: PayloadWrapper(value: TestSingleValueOptionalPayload(rawValue: 32))
		)
	}

	func testSingleValueDefaultEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestSingleValueDefaultPayload(rawValue: 86)),
			expected: """
			{
			  "value" : 86
			}
			"""
		)
	}

	func testSingleValueDefaultDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 86
			}
			""",
			expected: PayloadWrapper(value: TestSingleValueOptionalPayload(rawValue: 86))
		)
	}

	func testSingleValueDefaultAlternateDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : null
			}
			""",
			expected: PayloadWrapper(value: TestSingleValueOptionalPayload())
		)
	}

	func testSingleValueComplexEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestSingleValueComplexPayload(rawValue: 96)),
			expected: """
			{
			  "value" : 96
			}
			"""
		)
	}

	func testSingleValueComplexDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 96
			}
			""",
			expected: PayloadWrapper(value: TestSingleValuePayload(rawValue: 96))
		)
	}

	func testEnumStringEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestEnumString.one),
			expected: """
			{
			  "value" : "one"
			}
			"""
		)
	}

	func testEnumStringDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : "two"
			}
			""",
			expected: PayloadWrapper(value: TestEnumString.two)
		)
	}

	func testEnumIntegerEncoding() throws {
		try CodableUtility.assertEncoding(
			PayloadWrapper(value: TestEnumInteger.one),
			expected: """
			{
			  "value" : 1
			}
			"""
		)
	}

	func testEnumIntegerDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 2
			}
			""",
			expected: PayloadWrapper(value: TestEnumInteger.two)
		)
	}
}

// MARK: - Supporting Data

@Codable
private struct TestKeyedPayload: Equatable {
	@Codable(.unserialized)
	var valueA: Int = 42

	@Codable("firstValue")
	var valueB: Float

	var valueC: Int = 2

	var valueD: Bool

	@Codable("secondValue")
	var valueE: Int = 16

	var valueF: String?
}

@Codable(.singleValue)
private struct TestSingleValuePayload: Equatable {
	let rawValue: Int
}

@Codable(.singleValue)
private struct TestSingleValueOptionalPayload: Equatable {
	var rawValue: Int?
}

@Codable(.singleValue)
private struct TestSingleValueDefaultPayload: Equatable {
	var rawValue: Int = 32
}

@Codable(.singleValue)
private struct TestSingleValueComplexPayload: Equatable {
	var rawValue: Int

	@Codable(.unserialized)
	var defaultedValue: Int = 4

	@Codable(.unserialized)
	var optionalValue: Int?
}

@Codable(.asString)
private enum TestEnumString {
	case zero
	case one
	case two
}

@Codable(.asInteger)
private enum TestEnumInteger {
	case zero
	case one
	case two
}

private struct PayloadWrapper<Payload: Codable & Equatable>: Codable, Equatable {
	let value: Payload
}
