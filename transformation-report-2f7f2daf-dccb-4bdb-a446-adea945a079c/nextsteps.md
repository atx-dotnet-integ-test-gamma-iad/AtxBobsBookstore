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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns that should be addressed.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test output carefully, paying attention to any failures that may be caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used `System.Data` or an ORM tied to .NET Framework, verify that the replacement libraries function correctly against your database.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test key workflows such as browsing, searching, and any data entry forms to confirm end-to-end behavior is intact.

### 7. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to ensure:

- Middleware registration is compatible with the modern .NET hosting model.
- Any legacy `HttpModules` or `HttpHandlers` from ASP.NET have been replaced with the appropriate ASP.NET Core middleware equivalents.
- Authentication and authorization configurations are correct.

### 8. Check for Removed or Changed APIs

Review the code for any use of APIs that were removed or significantly changed in the transition from .NET Framework, such as:

- `System.Web` references (these are not available in modern .NET)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext.Current` (replaced by dependency-injected `IHttpContextAccessor`)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if a more thorough API audit is needed.