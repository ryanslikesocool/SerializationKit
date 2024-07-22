// swift-tools-version: 5.10

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
	],
	products: [
		.library(name: "SerializationKit", targets: [
			"SerializationKit",
		]),
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.2"),
	],
	targets: [
		.target(name: "SerializationKit", dependencies: [
			"SerializationKitMacrosPlugin",
		]),

		// MARK: - Plugins

		.macro(name: "SerializationKitMacrosPlugin", dependencies: [
			.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
			.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
		]),

		// MARK: - Tests

		.testTarget(
			name: "SerializationKitTests",
			dependencies: ["SerializationKit"]
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
