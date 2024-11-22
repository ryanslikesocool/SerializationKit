// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
	name: "SerializationKit",
	defaultLocalization: "en",
	platforms: [
		.macOS(.v12),
		.iOS(.v15),
		.tvOS(.v15),
		.watchOS(.v8),
		.macCatalyst(.v15),
		.visionOS(.v1),
	],
	products: [
		.library(
			name: "SerializationKit",
			targets: [
				"SerializationKit",
			]
		),
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
	],
	targets: [
		.target(
			name: "SerializationKit",
			dependencies: [
				"SerializationKit_Core",
				"SerializationKit_PropertyList",
				"SerializationKitMacrosPlugin",
			],
			swiftSettings: [
				.swiftLanguageMode(.v5),
			]
		),

		.target(name: "SerializationKit_PropertyList"),

		.target(name: "SerializationKit_Core"),

		// MARK: - Plugins

		.macro(
			name: "SerializationKitMacrosPlugin",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
				"SerializationKit_Core",
			]
		),

		// MARK: - Tests

		.testTarget(
			name: "SerializationKitTests",
			dependencies: [
				"SerializationKit",
			]
		),

		.testTarget(
			name: "SerializationKitMacrosTests",
			dependencies: [
				"SerializationKitMacrosPlugin",
				.product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
			]
		),
	]
)
