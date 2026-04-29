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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Run the Application Locally

Start the web application to confirm it runs as expected on the new .NET runtime:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise its core functionality, including any database interactions handled by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 5. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that your database connection strings in `appsettings.json` are correctly configured for the target environment. If migrations are present, apply them to verify they execute without error:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 7. Review Removed or Changed APIs

Check for any use of APIs that existed in .NET Framework but have changed behavior or limited support in cross-platform .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs that may compile but fail at runtime on non-Windows platforms
- Any third-party libraries that may not have cross-platform support

### 8. Test on Target Platform

If the intended deployment platform is Linux or macOS, run and test the application on that platform directly to surface any runtime issues that would not appear on Windows.