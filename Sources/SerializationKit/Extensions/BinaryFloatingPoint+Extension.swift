import Foundation

public extension BinaryFloatingPoint where Self: SerializedObjectConvertible {
    func serialize() -> Any { self }
}
