import Foundation

/// A `SerializedDictionaryConvertible` with `plist` data conversion.
public protocol PlistDictionaryConvertible: SerializedDictionaryConvertible, SerializedDataConvertible {
	static var format: PropertyListSerialization.PropertyListFormat { get }
}

public extension PlistDictionaryConvertible {
	init(data: Data) throws {
		do {
			let dictionary = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: .none) as! [String: Any]
			self.init(dictionary: dictionary)
		} catch {
			throw CocoaError(.fileReadCorruptFile)
		}
	}

	func toData() throws -> Data {
		try toData(format: Self.format)
	}

	func toData(format: PropertyListSerialization.PropertyListFormat) throws -> Data {
		try SerializationUtility.toPlistData(self, format: format)
	}
}
