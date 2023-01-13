import Foundation

/// The base protocol for an object that can be serialized into a ``Data`` object.
public protocol SerializedDataConvertible: Serializable {
    init(data: Data) throws
    func toData() throws -> Data
}
