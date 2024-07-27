import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
#if canImport(SerializationKitMacrosPlugin)
@testable import SerializationKitMacrosPlugin

private let testMacros: [String: Macro.Type] = [
	"Codable": CodableMacro.self,
]
#endif

final class CodableMacroSingleValueTests: XCTestCase {
	func testExpansionSingleValueSimple() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable(.singleValue)
			struct TestObject {
			    var rawValue: Int
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var rawValue: Int
			}

			extension TestObject: Codable {
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.singleValueContainer()
			        self.rawValue = try container.decode(Int.self)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.singleValueContainer()
			        try container.encode(rawValue)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

	func testExpansionSingleValueOptional() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable(.singleValue)
			struct TestObject {
			    var rawValue: Int?
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var rawValue: Int?
			}

			extension TestObject: Codable {
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.singleValueContainer()
			        self.rawValue = try container.decode(Int?.self)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.singleValueContainer()
			        try container.encode(rawValue)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

	func testExpansionSingleValueDefaultValue() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable(.singleValue)
			struct TestObject {
			    var rawValue: Int = 32
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var rawValue: Int = 32
			}

			extension TestObject: Codable {
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.singleValueContainer()
			        if let rawValue = try container.decode(Int?.self) {
			            self.rawValue = rawValue
			        }
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.singleValueContainer()
			        try container.encode(rawValue)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

	func testExpansionSingleValueComplex() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable(.singleValue)
			struct TestObject {
			    var rawValue: Int
			    @Codable(.unserialized)
			    var defaultedValue: Int = 4
			    @Codable(.unserialized)
			    var optionalValue: Int?
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var rawValue: Int
			    var defaultedValue: Int = 4
			    var optionalValue: Int?
			}

			extension TestObject: Codable {
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.singleValueContainer()
			        self.rawValue = try container.decode(Int.self)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.singleValueContainer()
			        try container.encode(rawValue)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}
}
