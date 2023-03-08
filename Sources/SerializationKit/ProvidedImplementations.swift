import Foundation

extension Bool: SerializedObjectConvertible { }
extension String: SerializedObjectConvertible { }

extension Float16: SerializedObjectConvertible { }
extension Float: SerializedObjectConvertible { }
extension Double: SerializedObjectConvertible { }

extension Int8: SerializedObjectConvertible { }
extension Int16: SerializedObjectConvertible { }
extension Int32: SerializedObjectConvertible { }
extension Int64: SerializedObjectConvertible { }
extension Int: SerializedObjectConvertible { }

extension UInt8: SerializedObjectConvertible { }
extension UInt16: SerializedObjectConvertible { }
extension UInt32: SerializedObjectConvertible { }
extension UInt64: SerializedObjectConvertible { }
extension UInt: SerializedObjectConvertible { }

extension Date: SerializedObjectConvertible { }
extension UUID: SerializedObjectConvertible { }
