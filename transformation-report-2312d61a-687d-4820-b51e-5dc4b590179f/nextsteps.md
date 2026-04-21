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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

### 5. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if any code paths rely on Windows-specific APIs. Review the following areas:

- File path handling — ensure `Path.Combine` is used instead of hardcoded backslashes.
- Registry access — this is not available on Linux or macOS.
- Windows Authentication — confirm the authentication strategy is compatible with your target platform.
- Any use of `System.Drawing` — this may require the `System.Drawing.Common` package and has platform limitations.

### 6. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and test core functionality including data access and page rendering.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string in `appsettings.json` is valid for the target environment. Apply any pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Deprecated or Removed APIs

Check for any use of APIs that were available in .NET Framework but have been removed or changed in cross-platform .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist with identifying these issues if they surface at runtime.