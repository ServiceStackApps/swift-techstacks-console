import PackageDescription

let package = Package(
    name: "TechStacks Console App",
    dependencies: [
        .Package(url: "https://github.com/ServiceStack/SwiftClient", majorVersion: 1)
    ]
)

