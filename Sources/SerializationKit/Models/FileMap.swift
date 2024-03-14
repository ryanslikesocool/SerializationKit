import Foundation

/// An object useful for encoding and decoding the order of files in a bundle or package.
public struct FileMap<ID: Hashable & Codable> {
	public static var fileName: String { ".file_map" }

	public var order: [ID]

	public init(_ order: [ID] = []) {
		self.order = order
	}

	public init<T: Identifiable>(_ elements: some Sequence<T>) where T.ID == ID {
		self.init(elements.map(\.id))
	}

	public func sort<T: Identifiable>(_ elements: some Sequence<T>) -> [T] where T.ID == ID {
		var sortIDs = order
		let remaining: [ID] = elements.map(\.id).filter { !sortIDs.contains($0) }
		sortIDs.append(contentsOf: remaining)

		return sortIDs.compactMap { id in
			elements.first(where: { $0.id == id })
		}
	}
}

// MARK: - Codable

public extension FileMap {
	init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		try self.init(container.decode([ID].self))
	}

	func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(order)
	}
}

// MARK: - PlistCodable

extension FileMap: PlistCodable {
	public static var propertyListFormat: PropertyListSerialization.PropertyListFormat { .xml }
}

// MARK: - FileWrapperConvertible

extension FileMap: FileWrapperConvertible { }
