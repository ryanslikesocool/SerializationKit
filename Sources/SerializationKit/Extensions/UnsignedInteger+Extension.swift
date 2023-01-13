import Foundation

public extension SerializedObjectConvertible where Self: UnsignedInteger & FixedWidthInteger {
    // `UnsignedInteger` does not conform to `FixedWidthInteger` (and `LosslessStringConvertible`,
    // via inheritance) by default, however, common unsigned integer types (`UInt8`, `UInt16`,
    // `UInt32`, `UInt64`, and `UInt`) conform to both.

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
}
