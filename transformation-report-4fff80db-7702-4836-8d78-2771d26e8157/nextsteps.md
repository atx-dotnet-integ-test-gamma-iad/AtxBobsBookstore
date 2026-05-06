# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Run a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failures before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Replaced APIs

Review the code in each project for any use of APIs that were available in .NET Framework but have been removed or altered in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` usage patterns specific to `System.Web`
- Any Windows-only APIs if cross-platform support is required

### 6. Review `Bookstore.Web` Configuration

In the `Bookstore.Web` project, verify the following:

- `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) are correctly configured for ASP.NET Core.
- Any `Web.config` settings that were previously used have been migrated to `appsettings.json`.
- Middleware registration order is correct.

### 7. Review `Bookstore.Data` for ORM Compatibility

If the project uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider package.
- Any migrations are present and up to date by running:

```bash
dotnet ef migrations list
```

- The database connection string in `appsettings.json` is correct for the target environment.

### 8. Run the Application Locally

Start the application locally to perform a basic smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and verify that core functionality, such as browsing and data retrieval, works as expected.

### 9. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` and that any unhandled exceptions surface correctly in the application output or log files.