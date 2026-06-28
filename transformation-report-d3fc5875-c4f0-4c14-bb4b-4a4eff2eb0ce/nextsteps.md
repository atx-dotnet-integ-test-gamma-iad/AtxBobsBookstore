# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced by the framework migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, exercise the following areas:

- **Data access**: Confirm that database connections and queries function correctly. If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Verify that business rules and domain model behavior are consistent with the original application.
- **Configuration**: Check that `appsettings.json` contains all required configuration values that may have previously resided in `Web.config` or `App.config`.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware-based auth, confirm that login, roles, and access control work as expected.

### 5. Check for Removed or Changed APIs

Review the code for any use of APIs that exist in .NET but behave differently from .NET Framework. Common areas to inspect include:

- `HttpContext` and request/response handling in `Bookstore.Web`
- Any use of `System.Web` namespaces, which are not available in cross-platform .NET
- `BinaryFormatter` or other serialization mechanisms that have been restricted or removed
- `ConfigurationManager`, which requires the `System.Configuration.ConfigurationManager` NuGet package if still in use

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment. Ensure the hosting environment has the correct .NET runtime version installed, which can be verified with:

```bash
dotnet --info
```