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
			SingleValueWrapperPayload(value: TestSingleValuePayload(rawValue: 12)),
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
			expected: SingleValueWrapperPayload(value: TestSingleValuePayload(rawValue: 12))
		)
	}

	func testSingleValueOptionalEncoding() throws {
		try CodableUtility.assertEncoding(
			SingleValueWrapperPayload(value: TestSingleValueOptionalPayload(rawValue: nil)),
			expected: """
			{
			  "value" : null
			}
			"""
		)
	}

	func testSingleValueOptionalAlternateEncoding() throws {
		try CodableUtility.assertEncoding(
			SingleValueWrapperPayload(value: TestSingleValueOptionalPayload(rawValue: 32)),
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
			expected: SingleValueWrapperPayload(value: TestSingleValueOptionalPayload(rawValue: nil))
		)
	}

	func testSingleValueOptionalAlternateDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : 32
			}
			""",
			expected: SingleValueWrapperPayload(value: TestSingleValueOptionalPayload(rawValue: 32))
		)
	}

	func testSingleValueDefaultEncoding() throws {
		try CodableUtility.assertEncoding(
			SingleValueWrapperPayload(value: TestSingleValueDefaultPayload(rawValue: 86)),
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
			expected: SingleValueWrapperPayload(value: TestSingleValueOptionalPayload(rawValue: 86))
		)
	}

	func testSingleValueDefaultAlternateDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : null
			}
			""",
			expected: SingleValueWrapperPayload(value: TestSingleValueOptionalPayload())
		)
	}

	func testSingleValueComplexEncoding() throws {
		try CodableUtility.assertEncoding(
			SingleValueWrapperPayload(value: TestSingleValueComplexPayload(rawValue: 96)),
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
			expected: SingleValueWrapperPayload(value: TestSingleValuePayload(rawValue: 96))
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

private struct SingleValueWrapperPayload<Payload: Codable & Equatable>: Codable, Equatable {
	let value: Payload
}
