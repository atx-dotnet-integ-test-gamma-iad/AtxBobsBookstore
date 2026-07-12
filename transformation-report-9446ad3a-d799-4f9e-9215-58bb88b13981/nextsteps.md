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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the selected target framework.

### 6. Run the Web Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and any data-driven pages operate correctly.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in modern .NET.
- `HttpContext` usage patterns that may differ in ASP.NET Core.
- Any Windows-specific APIs (e.g., registry access, `System.Drawing` without a compatibility package).

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility issues.

### 8. Check Application Configuration

Ensure that configuration files have been properly migrated:

- `Web.config` settings should be moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Middleware previously configured via `Web.config` (e.g., authentication, custom headers) should now be configured in `Program.cs` or `Startup.cs`.

### 9. Validate Logging and Error Handling

Confirm that logging is correctly configured using the built-in `Microsoft.Extensions.Logging` infrastructure or a compatible third-party provider such as Serilog or NLog.

## Deployment

### 1. Publish the Application

Generate a publish-ready output using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.

### 3. Deploy to Target Environment

Copy the published output to the target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed. The required runtime version can be confirmed by checking the `<TargetFramework>` in the `.csproj` file and downloading the corresponding runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).