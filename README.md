# Swift Package TechStacks Console App

This project contains an example of 
[building a Swift Console App using Swift's Package Manager](https://swift.org/package-manager/#importing-dependencies)
which leverages [ServiceStack's Swift Client](http://docs.servicestack.net/swift-add-servicestack-reference) support
and its Swift v3 [SwiftClient](https://github.com/ServiceStack/SwiftClient) Package to call 
[techstacks.io](http://techstacks.io) Web Services.

## Creating a Swift Package from Scratch

The guideline below will go through building and running this Example Swift Console App from Scratch.
See Apple's documentation for a more detailed illustration of [building Apps using Swift's Package Manager](https://swift.org/package-manager/#example-usage).

### Create a Directory for your Swift App

Create and change into the directory for your new Swift App project:

    mkdir swift-techstacks-console && cd swift-techstacks-console

### Declare Package dependencies

Every Swift Package App needs a `Package.swift` manifest file which amongst other things is where you'll specify
all the dependency your App needs. In this case the only dependency we need is the **ServiceStackClient** package
that's contained in the [SwiftClient](https://github.com/ServiceStack/SwiftClient) Github project, which you can
specify by pasting in the following Swift code in `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "ServiceStackClient",
    dependencies: [
        .Package(url: "https://github.com/ServiceStack/SwiftClient", majorVersion: 1)
    ]
)
```

Or if preferred, you can copy and save it from Github:

    curl https://raw.githubusercontent.com/ServiceStackApps/swift-techstacks-console/master/Package.swift > Package.swift 

### Install Packages 

To install your Projects dependencies run:

    swift build

Which will download the **ServiceStackClient** package and its transitive dependencies **PromiseKit** and copy it 
in the local `Packages/` folder: 

    Packages/
        ServiceStackClient-1.0.1/
        PromiseKit-4.1.3/

Since our `Package.swift` specifies `majorVersion: 1`, Swift automatically downloads the 
[latest Github release](https://github.com/ServiceStack/SwiftClient/releases) containing a `1.*` version number.

In addition to downloading the source code for each Package, Swift also builds each package from Source and
saves its build artifacts in the local `.build/` folder.

### Create your App

By convention, Swift expects your source files to be maintained in the local `Sources/` folder which we
can maintain in an implicit `Sources/{PackageName}` naming convention that we can create with: 

    mkdir -p Sources/App && cd Sources/App

By convention, a package containing a file named `main.swift` in its root directory produces an executable which
we can enable for our App by pasting the following code in `main.swift`:

```swift
import ServiceStackClient;

let client = JsonServiceClient(baseUrl:"http://techstacks.io")

let request = GetTechnology()
request.slug = "ServiceStack"

let response = try client.get(request)

print(response.technologyStacks[0].toJson());
```

Or if it's easier you can copy it from Github:

    curl https://raw.githubusercontent.com/ServiceStackApps/swift-techstacks-console/master/Sources/App/main.swift > main.swift 

Our Console App is fairly straight forward, it just uses the Swift ServiceClient in the **ServiceStackClient** package
to call a JSON Web Service by sending a Typed DTO to `http://techstacks.io` then prints the first Technology Stack 
result to the Console output.  

### Download TechStacks Typed Swift DTOs

We can download the Typed Swift DTO's for any remote ServiceStack Service by calling its built-in `/types/swift` route. 
Since we're using a Swift Package (instead of importing the ServiceClient directly in Xcode) we also need to override 
the default imports to include the **ServiceStackClient** package which we download from 
[techstacks.io](http://techstacks.io) and save into `TechStacks.dtos.swift` by running:

    curl http://techstacks.io/types/swift?DefaultImports=Foundation,ServiceStackClient > TechStacks.dtos.swift

Now that we have our completed app we can go back to the project's root directory and build the entire solution with:

    cd ../..
    swift build

If successful you should see something like:

    iMac:swift-techstacks-console mythz$ swift build
    Compile Swift Module 'App' (2 sources)
    Linking ./.build/debug/App

The result of which is a statically-linked native .exe in the `.build` folder which can be run as-is:

    ./.build/debug/App

Which should print the JSON output of the first Technology Stack result that uses `ServiceStack`, e.g:

```json
{"id":92,"name":"Recommend","vendorName":"Recommend","Description":"Recommendations from people you trust\nPowered by trust, Recommend enables you to find the best recommendations from people you know, save your own relevant experiences and share them with your private network only or become a trusted influencer.","appUrl":"http://re.co","screenshotUrl":"https://raw.githubusercontent.com/ServiceStack/Assets/master/img/livedemos/techstacks/screenshots/recommend.png","created":"/Date(1424470776472-0000)/","createdBy":"FlagSystemes","lastModified":"/Date(1479420525835-0000)/","lastModifiedBy":"FlagSystemes","isLocked":false,"ownerId":"30","slug":"recommend","details":null,"lastStatusUpdate":"/Date(1479420525835-0000)/"}
```

