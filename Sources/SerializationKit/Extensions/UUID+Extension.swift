import Foundation

extension UUID {
    public init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let str as any StringProtocol:
                if let this = Self(uuidString: String(str)) {
                    self = this
                } else {
                    fallthrough
                }
            default: return nil
        }
    }

    public func serialize() -> RootSerializable { uuidString }
}
