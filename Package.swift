// swift-tools-version: 5.7

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
		.library(
			name: "SerializationKit",
			targets: ["SerializationKit"]
		),
	],
	dependencies: [],
	targets: [
		.target(name: "SerializationKit", dependencies: []),
	]
)
