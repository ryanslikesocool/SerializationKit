import Foundation

/// An object useful for encoding and decoding the order of files in a bundle or package.
public struct FileMap<ID>
	where ID: Hashable & Codable
{
	public var order: [ID]

	public init(order: [ID] = []) {
		self.order = order
	}

	public init<Element>(elements: some Sequence<Element>) where
		Element: Identifiable,
		Element.ID == ID
	{
		self.init(order: elements.map(\.id))
	}

	public func sort<Element>(_ elements: some Sequence<Element>) -> [Element] where
		Element: Identifiable,
		Element.ID == ID
	{
		var sortIDs = order
		let remaining: [ID] = elements
			.map(\.id)
			.filter { (id: ID) -> Bool in
				!sortIDs.contains(id)
			}
		sortIDs.append(contentsOf: consume remaining)

		return sortIDs.compactMap { (id: ID) -> Element? in
			elements.first { (element: Element) -> Bool in
				element.id == id
			}
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

// MARK: - Constants

public extension FileMap {
	static var fileName: String { ".file_map" }
}
