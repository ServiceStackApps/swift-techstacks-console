import ServiceStackClient;

let client = JsonServiceClient(baseUrl:"http://techstacks.io")

let request = GetTechnology()
request.slug = "ServiceStack"

let response = try client.get(request)

print(response.technologyStacks[0].toJson());

