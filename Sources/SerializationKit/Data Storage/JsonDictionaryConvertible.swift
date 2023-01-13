import Foundation

/// A `SerializedDictionaryConvertible` with `json` data conversion.
public protocol JsonDictionaryConvertible: SerializedDictionaryConvertible, SerializedDataConvertible {}

public extension JsonDictionaryConvertible {
    init(data: Data) throws {
        do {
			let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: RootSerializable]
            self.init(dictionary: dictionary)
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func toData() throws -> Data {
        try SerializationUtility.toJsonData(self)
    }
}
