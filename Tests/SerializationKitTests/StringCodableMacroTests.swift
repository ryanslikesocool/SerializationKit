@testable import SerializationKit
import XCTest

final class StringCodableMacroTests: XCTestCase {
	func testEncoding() throws {
		try CodableUtility.assertEncoding(
			TestPayload(value: .one),
			expected: """
			{
			  "value" : "one"
			}
			"""
		)
	}

	func testDecoding() throws {
		try CodableUtility.assertDecoding(
			"""
			{
			  "value" : "two"
			}
			""",
			expected: TestPayload(value: .two)
		)
	}
}

// MARK: - Supporting Data

@StringCodable
private enum TestEnum: Int {
	case zero
	case one
	case two
}

private struct TestPayload: Codable, Equatable {
	let value: TestEnum
}
