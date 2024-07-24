import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SerializationKitMacrosPlugin)
@testable import SerializationKitMacrosPlugin

private let testMacros: [String: Macro.Type] = [
	"Codable": CodableMacro.self,
]
#endif

final class CodableMacroTests: XCTestCase {
	func testKeyed() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable
			struct TestObject {
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
			""",
			expandedSource:
			"""
			struct TestObject {
			    var valueA: Int = 42
			    var valueB: Float
			    var valueC: Int = 2
			    var valueD: Bool
			    var valueE: Int = 16
			    var valueF: String?
			}

			extension TestObject: Codable {
			    private enum __CodingKeys: String, CodingKey {
			        case valueB = "firstValue"
			        case valueC
			        case valueD
			        case valueE = "secondValue"
			        case valueF
			    }
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.container(keyedBy: __CodingKeys.self)
			        self.valueB = try container.decode(Float.self, forKey: __CodingKeys.valueB)
			        if let valueC = try container.decodeIfPresent(Int.self, forKey: __CodingKeys.valueC) {
			            self.valueC = valueC
			        }
			        self.valueD = try container.decode(Bool.self, forKey: __CodingKeys.valueD)
			        if let valueE = try container.decodeIfPresent(Int.self, forKey: __CodingKeys.valueE) {
			            self.valueE = valueE
			        }
			        self.valueF = try container.decodeIfPresent(String.self, forKey: __CodingKeys.valueF)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.container(keyedBy: __CodingKeys.self)
			        try container.encode(valueB, forKey: __CodingKeys.valueB)
			        try container.encode(valueC, forKey: __CodingKeys.valueC)
			        try container.encode(valueD, forKey: __CodingKeys.valueD)
			        try container.encode(valueE, forKey: __CodingKeys.valueE)
			        try container.encodeIfPresent(valueF, forKey: __CodingKeys.valueF)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

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
