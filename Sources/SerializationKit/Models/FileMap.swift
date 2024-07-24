import Foundation

/// An object useful for encoding and decoding the order of files in a bundle or package.
public struct FileMap<ID>
	where ID: Hashable & Codable
{
	public static var fileName: String { ".file_map" }

	public var order: [ID]

	public init(order: [ID] = []) {
		self.order = order
	}

	public init<T: Identifiable>(elements: some Sequence<T>) where T.ID == ID {
		self.init(order: elements.map(\.id))
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

extension FileMap: Codable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		try self.init(order: container.decode([ID].self))
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(order)
	}
}

// MARK: - PropertyListCodable

extension FileMap: PropertyListCodable {
	public static var propertyListFormat: PropertyListFormat { .binary }
}

// MARK: - FileWrapperConvertible

extension FileMap: FileWrapperConvertible { }
