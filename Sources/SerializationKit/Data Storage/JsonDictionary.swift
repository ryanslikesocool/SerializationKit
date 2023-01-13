import Foundation

/// A `SerializedDictionaryConvertible` with `json` data conversion.
public protocol JsonDictionary: SerializedDictionaryConvertible, SerializedDataConvertible {}

public extension JsonDictionary {
    init(data: Data) throws {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! SerializedDictionary
            self.init(dictionary: dictionary)
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func toData() throws -> Data {
        try Serialization.toJsonData(self)
    }
}
