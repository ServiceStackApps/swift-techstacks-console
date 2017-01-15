import PackageDescription

let package = Package(
    name: "ServiceStackClient",
    dependencies: [
        .Package(url: "https://github.com/ServiceStack/SwiftClient", majorVersion: 1)
    ]
)

