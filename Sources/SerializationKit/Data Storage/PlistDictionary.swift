import Foundation

/// A `SerializedDictionaryConvertible` with `plist` data conversion.
public protocol PlistDictionary: SerializedDictionaryConvertible, SerializedDataConvertible {
    var format: PropertyListSerialization.PropertyListFormat { get }
}

public extension PlistDictionary {
    init(data: Data) throws {
        do {
            let dictionary = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainersAndLeaves], format: .none) as! [String: any RootSerializable]
            self.init(dictionary: dictionary)
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func toData() throws -> Data {
        try toData(format: format)
    }

    func toData(format: PropertyListSerialization.PropertyListFormat) throws -> Data {
        try Serialization.toPlistData(self, format: format)
    }
}
