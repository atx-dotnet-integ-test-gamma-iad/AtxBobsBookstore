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

Review the output for any warnings related to package compatibility or version conflicts, particularly around packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the build output for any warnings that, while non-fatal, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the transformation:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer

Since `Bookstore.Data` is likely responsible for database access, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the version of .NET being targeted.

### 5. Run the Web Application Locally

Start the application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows function as expected.

### 6. Review Configuration

Cross-platform .NET handles configuration differently than .NET Framework. Confirm the following:

- `Web.config` transforms or settings have been moved to `appsettings.json` or `appsettings.{Environment}.json` where applicable.
- Environment-specific settings (e.g., connection strings, API keys) are not hardcoded and are sourced from environment variables or configuration files.
- Any `system.web` or IIS-specific configuration that existed in the original `Web.config` has been accounted for in the new hosting model.

### 7. Review Middleware and HTTP Pipeline

If the project previously used HTTP Modules or HTTP Handlers, confirm they have been replaced with the equivalent ASP.NET Core middleware. Check `Program.cs` or `Startup.cs` to ensure the middleware pipeline is configured correctly, including:

- Static file serving
- Routing
- Authentication and authorization middleware
- Session and cookie configuration

### 8. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS if cross-platform support is a requirement:

```bash
grep -rn "Registry\|System.Drawing\|System.Web\|HttpContext.Current" --include="*.cs"
```

Address any findings by replacing them with cross-platform alternatives.