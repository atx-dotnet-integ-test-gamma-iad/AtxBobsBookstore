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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

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

If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database connection strings are correctly configured for the new runtime. Check the following:

- `appsettings.json` or `appsettings.Development.json` in `Bookstore.Web` for valid connection strings.
- Run any pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the reported local URL and exercise the core features of the application to confirm expected behavior.

### 7. Review Removed Windows-Specific APIs

Check the codebase for any references to APIs that are Windows-specific and may have been silently retained or stubbed during transformation. Common areas to inspect include:

- `System.Web` references (should no longer be present)
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Configuration System

ASP.NET Core uses a different configuration model than legacy ASP.NET. Confirm that:

- `Web.config` settings have been migrated to `appsettings.json`
- Any `ConfigurationManager` usages have been replaced with the `IConfiguration` interface
- Environment-specific settings are handled via `appsettings.{Environment}.json`

### 9. Static Files and Middleware

Verify that static files (CSS, JavaScript, images) are served correctly and that the middleware pipeline in `Program.cs` or `Startup.cs` is configured in the correct order, including:

- `UseStaticFiles()`
- `UseRouting()`
- `UseAuthentication()` / `UseAuthorization()` if applicable