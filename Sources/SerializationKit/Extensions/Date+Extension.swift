import Foundation

extension Date {
	public typealias RootSerializedType = Double

    public init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let dbl as Double: self = Date(timeIntervalSinceReferenceDate: dbl)
            case let str as any StringProtocol:
                if let date = try? Self(str, strategy: .iso8601) {
                    self = date
                } else {
                    fallthrough
                }
            default: return nil
        }
    }

    public func serialize() -> RootSerializedType { timeIntervalSinceReferenceDate }
}
