import Foundation

extension String {
    public init?(unwrap any: Any?) {
        switch any {
            case let this as Self: self = this
            case let str as any StringProtocol: self = String(str)
            default: return nil
        }
    }

	public func serialize() -> Any { self }
}
