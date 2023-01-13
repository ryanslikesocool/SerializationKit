import Foundation

public extension FixedWidthInteger where Self: SerializedObjectConvertible {
    func serialize() -> Any { self }
}
