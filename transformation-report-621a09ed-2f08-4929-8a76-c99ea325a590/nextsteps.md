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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm runtime behavior is correct.

### 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that the database connection string in `appsettings.json` is valid for the current environment. If migrations are used, apply them with:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check for Windows-Specific APIs

Even without build errors, the code may reference APIs that are Windows-only and will fail at runtime on Linux or macOS. Search the codebase for usages of APIs such as the Windows Registry, `System.Drawing`, or Windows-specific file path assumptions. The .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling can assist with this review.

### 8. Review `appsettings.json` and Configuration

Confirm that configuration files are present and correctly structured for the new hosting model. In cross-platform .NET, `web.config` is no longer the primary configuration source. Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all required settings.

### 9. Validate Static Assets and Middleware

If the project uses static files, bundling, or custom middleware that was previously handled by IIS modules, verify that the equivalent middleware is registered in `Program.cs` or `Startup.cs`, for example:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
```

### 10. Test on Target Platform

If the goal is to run on Linux or macOS, perform a test run on that operating system to surface any platform-specific runtime issues that would not appear on Windows.