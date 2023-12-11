import Foundation

enum CodableUtility {
	static let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		return encoder
	}()

	static let decoder: JSONDecoder = JSONDecoder()

	enum Error: Swift.Error {
		case dataToStringFailure
		case stringToDataFailure
	}
}

extension CodableUtility {
	static func encode<T: Encodable>(_ value: T) throws -> String {
		let data = try encoder.encode(value)
		guard let string = String(data: data, encoding: .utf8) else {
			throw Error.dataToStringFailure
		}
		return string
	}

	static func decode<T: Decodable>(_ string: String) throws -> T {
		guard let data = string.data(using: .utf8) else {
			throw Error.stringToDataFailure
		}
		return try decoder.decode(T.self, from: data)
	}
}
