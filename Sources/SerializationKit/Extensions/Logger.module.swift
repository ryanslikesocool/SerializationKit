import OSLog

package extension Logger {
	@usableFromInline
	static let module: Self = Self(
		subsystem: "SerializationKit",
		category: "SerializationKit"
	)
}
