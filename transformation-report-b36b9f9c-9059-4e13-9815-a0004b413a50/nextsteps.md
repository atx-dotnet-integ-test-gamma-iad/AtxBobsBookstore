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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

### 5. Review Removed or Replaced APIs

Check the codebase for any usage of APIs that were removed or significantly changed in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages — confirm they reference `Microsoft.AspNetCore.Http` and not `System.Web`.
- Any use of `ConfigurationManager` — this should be replaced with `Microsoft.Extensions.Configuration`.
- `BinaryFormatter` — this has been disabled by default and should be replaced with a supported serialization mechanism.

### 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core package is referenced and that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary workflows, such as browsing, searching, and any data entry forms.

### 8. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or P/Invoke calls that may cause runtime failures on non-Windows platforms:

```bash
grep -rn "DllImport\|Registry\|Environment.SpecialFolder" --include="*.cs"
```

Address any findings by replacing them with cross-platform alternatives or conditionally compiling them using runtime checks.

### 9. Review Application Configuration

Confirm that `appsettings.json` contains all configuration values that were previously stored in `Web.config` or `App.config`, including connection strings and application settings. The legacy config files are not used in cross-platform .NET.