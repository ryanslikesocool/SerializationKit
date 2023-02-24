import Foundation

extension Range: SerializedDictionaryConvertible & Serializable where Bound: SerializedObjectConvertible {
	public init(dictionary: [String: Any]) {
		let lowerBound: Bound! = Bound(unwrap: dictionary["lowerBound"])
		let upperBound: Bound! = Bound(unwrap: dictionary["upperBound"])
		self.init(uncheckedBounds: (lowerBound, upperBound))
	}

	public func toDictionary() -> [String: Any?] {
		[
			"lowerBound": lowerBound,
			"upperBound": upperBound,
		]
	}
}
