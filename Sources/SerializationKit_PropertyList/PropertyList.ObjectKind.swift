public extension PropertyList {
	enum ObjectKind {
		case boolean
		case integer
		case real
		case string
		case date
		case data
		case array
		case dictionary
	}
}

// MARK: - Sendable

extension PropertyList.ObjectKind: Sendable { }

// MARK: - Equatable

extension PropertyList.ObjectKind: Equatable { }

// MARK: - Hashable

extension PropertyList.ObjectKind: Hashable { }
