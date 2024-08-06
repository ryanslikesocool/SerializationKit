import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
#if canImport(SerializationKitMacrosPlugin)
@testable import SerializationKitMacrosPlugin

private let testMacros: [String: Macro.Type] = [
	"Codable": CodableMacro.self,
]
#endif

final class CodableMacroKeyedTests: XCTestCase {
	func testKeyedComplex() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable
			struct TestObject {
			    static var value0: Int = 1
			    @Codable(.unserialized)
			    var valueA: Int = 42
			    @Codable("firstValue")
			    var valueB: Float
			    var valueC: Int = 2
			    var valueD: Bool
			    @Codable("secondValue")
			    var valueE: Int = 16
			    var valueF: String?
			    var valueG: Int { valueC }
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    static var value0: Int = 1
			    var valueA: Int = 42
			    var valueB: Float
			    var valueC: Int = 2
			    var valueD: Bool
			    var valueE: Int = 16
			    var valueF: String?
			    var valueG: Int { valueC }
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

	func testKeyedNoCustom() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable
			struct TestObject {
			    @Codable(.unserialized)
			    var valueA: Int = 42
			    var valueB: Int = 2
			    var valueC: Bool
			    var valueD: String?
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var valueA: Int = 42
			    var valueB: Int = 2
			    var valueC: Bool
			    var valueD: String?
			}

			extension TestObject: Codable {
			    private enum __CodingKeys: CodingKey {
			        case valueB
			        case valueC
			        case valueD
			    }
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.container(keyedBy: __CodingKeys.self)
			        if let valueB = try container.decodeIfPresent(Int.self, forKey: __CodingKeys.valueB) {
			            self.valueB = valueB
			        }
			        self.valueC = try container.decode(Bool.self, forKey: __CodingKeys.valueC)
			        self.valueD = try container.decodeIfPresent(String.self, forKey: __CodingKeys.valueD)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.container(keyedBy: __CodingKeys.self)
			        try container.encode(valueB, forKey: __CodingKeys.valueB)
			        try container.encode(valueC, forKey: __CodingKeys.valueC)
			        try container.encodeIfPresent(valueD, forKey: __CodingKeys.valueD)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

	func testExpansionKeyedMultipleBindingsSimple() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable
			struct TestObject {
			    var x, y, z: Int
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var x, y, z: Int
			}

			extension TestObject: Codable {
			    private enum __CodingKeys: CodingKey {
			        case x
			        case y
			        case z
			    }
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.container(keyedBy: __CodingKeys.self)
			        self.x = try container.decode(Int.self, forKey: __CodingKeys.x)
			        self.y = try container.decode(Int.self, forKey: __CodingKeys.y)
			        self.z = try container.decode(Int.self, forKey: __CodingKeys.z)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.container(keyedBy: __CodingKeys.self)
			        try container.encode(x, forKey: __CodingKeys.x)
			        try container.encode(y, forKey: __CodingKeys.y)
			        try container.encode(z, forKey: __CodingKeys.z)
			    }
			}
			""",
			macros: testMacros
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}

	func testExpansionKeyedMultipleBindingsMultipleTypes() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@Codable
			struct TestObject {
			    var x, y: Int, z: Float
			}
			""",
			expandedSource:
			"""
			struct TestObject {
			    var x, y: Int, z: Float
			}

			extension TestObject: Codable {
			    private enum __CodingKeys: CodingKey {
			        case x
			        case y
			        case z
			    }
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.container(keyedBy: __CodingKeys.self)
			        self.x = try container.decode(Int.self, forKey: __CodingKeys.x)
			        self.y = try container.decode(Int.self, forKey: __CodingKeys.y)
			        self.z = try container.decode(Float.self, forKey: __CodingKeys.z)
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.container(keyedBy: __CodingKeys.self)
			        try container.encode(x, forKey: __CodingKeys.x)
			        try container.encode(y, forKey: __CodingKeys.y)
			        try container.encode(z, forKey: __CodingKeys.z)
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
