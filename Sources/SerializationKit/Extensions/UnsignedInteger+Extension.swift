import Foundation

public extension SerializedObjectConvertible where Self: UnsignedInteger & FixedWidthInteger {
    init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let str as any StringProtocol:
                let this: Self?
                if str.hasPrefix("0x") {
                    let str = String(str)
                    this = Self(str.dropFirst(2), radix: Self.bitWidth >> 2)
                } else {
                    this = Self(str)
                }
                if let this {
                    self = this
                } else {
                    fallthrough
                }
            default: return nil
        }
    }

    func serialize() -> Any { self }
}
