import Foundation
#if canImport(OSLog)
import OSLog
#endif

// MARK: - Logging

fileprivate func logEncodingFailure(metatypeAccessor: Any.Type, value: Any) {
	#if canImport(OSLog)
	if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
		Logger.module.error("Failed to find a valid metatype in \(metatypeAccessor) for the given value \(String(describing: value))")
	} else {
		printLog()
	}
	#else
	printLog()
	#endif

	func printLog() {
		print("Failed to find a valid metatype in \(metatypeAccessor) for the given value \(value)")
	}
}

// MARK: -

public extension KeyedEncodingContainer {
	mutating func encode<T: CodableMetatypeAccessor, U: Codable>(_ value: U, using metatype: T.Type, forKey key: Key) throws {
		let valueType = type(of: value)
		guard let base = T.allCases.first(where: { metatype in metatype.encodableMetatype == valueType }) else {
			// TODO: throw instead of logging
			logEncodingFailure(metatypeAccessor: metatype, value: value)
			return
		}
		try encode(CodablePayload<T>(value, base: base), forKey: key)
	}

	mutating func encode<T: CodableMetatypeAccessor>(_ values: [any Codable], using metatype: T.Type, forKey key: Key) throws {
		let encodingValue = values.compactMap { value -> CodablePayload<T>? in
			let valueType = type(of: value)
			guard let base = T.allCases.first(where: { metatype in metatype.encodableMetatype == valueType }) else {
				// TODO: throw instead of logging
				logEncodingFailure(metatypeAccessor: metatype, value: value)
				return nil
			}
			return CodablePayload(value, base: base)
		}
		try encode(encodingValue, forKey: key)
	}

//	mutating func encode(_ values: [any Encodable], forKey key: KeyedEncodingContainer<K>.Key) throws {
//		var container = nestedUnkeyedContainer(forKey: key)
//		for value in values {
//			try container.encode(value)
//		}
//	}
}

// MARK: - If Present

public extension KeyedEncodingContainer {
	mutating func encodeIfPresent<T: CodableMetatypeAccessor, U: Codable>(_ value: U?, using metatype: T.Type, forKey key: Key) throws {
		guard let value else {
			return
		}
		try encode(value, using: metatype, forKey: key)
	}

	mutating func encodeIfPresent<T: CodableMetatypeAccessor>(_ values: [any Codable]?, using metatype: T.Type, forKey key: Key) throws {
		guard let values else {
			return
		}
		try encode(values, using: metatype, forKey: key)
	}
}
