import Foundation

public extension RawRepresentable where RawValue: SerializedObject {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let value as RawValue:
                if let this = Self(rawValue: value) {
                    self = this
                } else {
                    fallthrough
                }
            default: return nil
        }
    }

    func serialize() -> any RootSerializable { rawValue.serialize() }
}
