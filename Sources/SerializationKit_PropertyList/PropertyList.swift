import Foundation

public enum PropertyList {
	case boolean(Bool)
	case integer(Int)
	case real(Double)
	case string(String)
	case date(Date)
	case data(Data)
	indirect case array([Self])
	indirect case dictionary([String: Self])
}

// MARK: - Sendable

extension PropertyList: Sendable { }

// MARK: - Equatable

extension PropertyList: Equatable { }

// MARK: - Hashable

extension PropertyList: Hashable { }

// MARK: - Codable

extension PropertyList: Codable {
	private struct CodingKeys: CodingKey {
		let stringValue: String
		let intValue: Int?

		init?(stringValue: String) {
			self.stringValue = stringValue
			intValue = nil
		}

		init?(intValue: Int) {
			return nil
		}
	}

	public init(from decoder: any Decoder) throws {
		if let container = try? decoder.container(keyedBy: CodingKeys.self) {
			self = try .dictionary(container.allKeys.reduce(into: [String: Self]()) { result, key in
				result[key.stringValue] = try container.decode(Self.self, forKey: key)
			})
		} else if var container = try? decoder.unkeyedContainer() {
			self = try .array((0 ..< (container.count ?? 0)).map { _ in
				try container.decode(Self.self)
			})
		} else if let container = try? decoder.singleValueContainer() {
			if let boolean = try? container.decode(Bool.self) {
				self = .boolean(boolean)
			} else if let integer = try? container.decode(Int.self) {
				self = .integer(integer)
			} else if let real = try? container.decode(Double.self) {
				self = .real(real)
			} else if let string = try? container.decode(String.self) {
				self = .string(string)
			} else if let date = try? container.decode(Date.self) {
				self = .date(date)
			} else if let data = try? container.decode(Data.self) {
				self = .data(data)
			} else {
				let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "")
				throw DecodingError.dataCorrupted(context)
			}
		} else {
			let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "")
			throw DecodingError.dataCorrupted(context)
		}
	}

	public func encode(to encoder: any Encoder) throws {
		switch self {
			case let .boolean(boolean):
				var container = encoder.singleValueContainer()
				try container.encode(boolean)
			case let .integer(integer):
				var container = encoder.singleValueContainer()
				try container.encode(integer)
			case let .real(real):
				var container = encoder.singleValueContainer()
				try container.encode(real)
			case let .string(string):
				var container = encoder.singleValueContainer()
				try container.encode(string)
			case let .date(date):
				var container = encoder.singleValueContainer()
				try container.encode(date)
			case let .data(data):
				var container = encoder.singleValueContainer()
				try container.encode(data)
			case let .array(array):
				var container = encoder.unkeyedContainer()
				for element in array {
					try container.encode(element)
				}
			case let .dictionary(dictionary):
				var container = encoder.container(keyedBy: CodingKeys.self)
				for (key, value) in dictionary {
					guard let key = CodingKeys(stringValue: key) else {
						// TODO: throw?
						continue
					}
					try container.encode(value, forKey: key)
				}
		}
	}
}

// MARK: - ExpressibleByBooleanLiteral

extension PropertyList: ExpressibleByBooleanLiteral {
	public init(booleanLiteral value: BooleanLiteralType) {
		self = .boolean(value)
	}
}

// MARK: - ExpressibleByIntegerLiteral

extension PropertyList: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: IntegerLiteralType) {
		self = .integer(value)
	}
}

// MARK: - ExpressibleByFloatLiteral

extension PropertyList: ExpressibleByFloatLiteral {
	public init(floatLiteral value: FloatLiteralType) {
		self = .real(value)
	}
}

// MARK: - ExpressibleByStringLiteral

extension PropertyList: ExpressibleByStringLiteral {
	public init(stringLiteral value: StringLiteralType) {
		self = .string(value)
	}
}

// MARK: - ExpressibleByArrayLiteral

extension PropertyList: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Self...) {
		self = .array(elements)
	}
}

// MARK: - ExpressibleByDictionaryLiteral

extension PropertyList: ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (String, Self)...) {
		self = .dictionary([String: Self](uniqueKeysWithValues: elements))
	}
}

// MARK: -

public extension PropertyList {
	var objectKind: ObjectKind {
		switch self {
			case .boolean: .boolean
			case .integer: .integer
			case .real: .real
			case .string: .string
			case .date: .date
			case .data: .data
			case .array: .array
			case .dictionary: .dictionary
		}
	}
}
