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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, especially those related to nullable reference types, deprecated APIs, or platform compatibility.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core or other data access configuration is functioning correctly. If the project uses EF Core migrations, verify they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Check for Windows-Specific APIs

Even without build errors, runtime issues can arise from APIs that were available in .NET Framework but behave differently or are unavailable on non-Windows platforms. Use the .NET Compatibility Analyzer or review the code manually for usage of:

- `System.Web` namespaces
- Windows Registry access
- Windows-specific file path assumptions
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Configuration Files

Confirm that any `Web.config` or `App.config` files from the original project have been replaced or supplemented with the appropriate `appsettings.json` configuration. Verify that connection strings, application settings, and environment-specific values are correctly defined.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

### 9. Validate Logging and Error Handling

Ensure that logging is configured correctly in `Program.cs` or `Startup.cs` using the built-in `Microsoft.Extensions.Logging` infrastructure, and that unhandled exceptions are surfaced appropriately during local testing.