import Foundation

// MARK: - Encodable -> PropertyList

public extension PropertyList {
	init(
		_ object: any Encodable,
		encoder: PropertyListEncoder? = nil,
		decoder: PropertyListDecoder? = nil
	) throws {
		let encoder = encoder ?? Self.defaultEncoder
		let decoder = decoder ?? Self.defaultDecoder

		// plist can't have single value container at top level
		// wrap in a dictionary when converting

		let encodingObject = EncodableObjectWrapper(object)
		let data = try encoder.encode(encodingObject)
		let decodedObject = try decoder.decode(DecodableObjectWrapper<PropertyList>.self, from: data)
		self = decodedObject.value
	}

	// MARK: - PropertyList -> Decodable

	func `as`<Object: Decodable>(
		_ objectType: Object.Type,
		encoder: PropertyListEncoder? = nil,
		decoder: PropertyListDecoder? = nil
	) throws -> Object {
		let encoder = encoder ?? Self.defaultEncoder
		let decoder = decoder ?? Self.defaultDecoder

		// plist can't have single value container at top level
		// wrap in a dictionary when converting

		let encodingObject = EncodableObjectWrapper(self)
		let data = try encoder.encode(encodingObject)
		let decodedObject = try decoder.decode(DecodableObjectWrapper<Object>.self, from: data)
		return decodedObject.value
	}
}

// MARK: - Constants

extension PropertyList {
	static let defaultEncoder: PropertyListEncoder = PropertyListEncoder()
	static let defaultDecoder: PropertyListDecoder = PropertyListDecoder()
}

// MARK: - Supporting Data

private extension PropertyList {
	enum ConversionCodingKeys: CodingKey {
		case value
	}

	struct EncodableObjectWrapper: Encodable {
		let value: any Encodable

		init(_ value: any Encodable) {
			self.value = value
		}

		func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: ConversionCodingKeys.self)
			try container.encode(value, forKey: .value)
		}
	}

	struct DecodableObjectWrapper<Object: Decodable>: Decodable {
		let value: Object

		init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: ConversionCodingKeys.self)
			value = try container.decode(Object.self, forKey: .value)
		}
	}

//	struct PropertyListWrapper: Codable {
//		let value: PropertyList
//
//		init(_ value: PropertyList) {
//			self.value = value
//		}
//
//		init(from decoder: any Decoder) throws {
//			let container = try decoder.container(keyedBy: ConversionCodingKeys.self)
//			value = try container.decode(PropertyList.self, forKey: .value)
//		}
//
//		func encode(to encoder: any Encoder) throws {
//			var container = encoder.container(keyedBy: ConversionCodingKeys.self)
//			try container.encode(value, forKey: .value)
//		}
//	}
}
