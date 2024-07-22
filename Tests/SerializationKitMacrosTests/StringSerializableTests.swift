import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SerializationKitMacrosPlugin)
@testable import SerializationKitMacrosPlugin

private let testMacros: [String: Macro.Type] = [
	"StringSerializable": StringSerializableMacro.self,
]
#endif

final class StringSerializableMacroTests: XCTestCase {
	func testStandard() throws {
#if canImport(SerializationKitMacrosPlugin)
		assertMacroExpansion(
			"""
			@StringSerializable
			enum MyEnum: UInt8 {
			    case zero
			    case one
			    case two
			}
			""",
			expandedSource:
			"""
			enum MyEnum: UInt8 {
			    case zero
			    case one
			    case two
			}

			extension MyEnum: Codable {
			    private enum __CodingValues: String, Codable {
			        case zero
			        case one
			        case two
			    }
			    public init(from decoder: any Decoder) throws {
			        let container = try decoder.singleValueContainer()
			        let codingValue: __CodingValues = try container.decode(__CodingValues.self)
			        self = switch codingValue {
			            case __CodingValues.zero: Self.zero
			            case __CodingValues.one: Self.one
			            case __CodingValues.two: Self.two
			        }
			    }
			    public func encode(to encoder: any Encoder) throws {
			        var container = encoder.singleValueContainer()
			        let codingValue: __CodingValues = switch self {
			            case Self.zero: __CodingValues.zero
			            case Self.one: __CodingValues.one
			            case Self.two: __CodingValues.two
			        }
			        try container.encode(codingValue)
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
