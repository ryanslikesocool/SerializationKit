#if canImport(SwiftUI)
import Foundation
import OSLog
import SwiftUI

/// A property wrapper that acts as a source of truth for a local file.
/// - Remark: `FileState` is backed by a ``SwiftUI/State`` property wrapper, and has the same limitations.
@propertyWrapper
public struct FileState<Value: Codable>: DynamicProperty {
	public typealias DefaultProvider = () -> Value
	public typealias WriteAction = (Value) -> Void

	@State private var value: Value?

	/// The default value to use.
	private let defaultProvider: DefaultProvider

	/// The action to perform when the underlying value has changed.  In most cases, this is writing the file back to the disk.
	private let write: WriteAction

	public var wrappedValue: Value {
		get {
			if let value {
				return value
			} else {
				let newValue: Value = defaultProvider()
				value = newValue
				return newValue
			}
		}
		nonmutating set {
			value = newValue
			write(newValue)
		}
	}

	public var projectedValue: Binding<Value> {
		Binding<Value>(
			get: { wrappedValue },
			set: { newValue in wrappedValue = newValue }
		)
	}

	/// - Parameters:
	///   - write: The action to perform when the underlying value has changed.  In most cases, this is writing the file back to the disk.
	///   - defaultValue: The default value to use.
	public init(
		write: @escaping WriteAction,
		default defaultValue: Value
	) {
		_value = State(wrappedValue: defaultValue)
		self.write = write
		defaultProvider = { defaultValue }
	}

	/// - Parameters:
	///   - url: The URL of the file to access.
	///   - defaultProvider: The default value to use when the file cannot be read from the given URL.
	public init(
		url: URL,
		default defaultProvider: @autoclosure @escaping DefaultProvider
	)
		where Value: SerializedDataConvertible & SerializedFileConvertible<Data.ReadingOptions, Data.WritingOptions>
	{
		self.init(
			write: { file in
				do {
					try file.write(to: url)
				} catch {
					Logger.module.error("""
					Failed  to write file to \(url.path):
					\(error.localizedDescription)
					""")
				}
			},
			default: {
				do {
					return try Value(contentsOf: url)
				} catch {
					Logger.module.error("""
					Failed to read file from \(url.path):
					\(error.localizedDescription)
					""")
					return defaultProvider()
				}
			}()
		)
	}
}
#endif
