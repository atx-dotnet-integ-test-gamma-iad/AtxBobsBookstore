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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all three projects.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover critical logic in `Bookstore.Domain` and `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correct and point to a valid database instance.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, data retrieval) to confirm end-to-end functionality.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were valid in .NET Framework but may behave differently on cross-platform .NET. Common areas to review include:

- `System.Web` references (should have been removed or replaced)
- Windows Registry access
- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Any P/Invoke calls targeting Windows-only native libraries

### 8. Review Middleware and Configuration

In `Bookstore.Web`, confirm that the application startup configuration (`Program.cs` or `Startup.cs`) follows the current .NET conventions and that any previously used `HttpModules` or `HttpHandlers` from ASP.NET have been correctly replaced with middleware.

### 9. Validate Logging and Error Handling

Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider, and that unhandled exceptions are surfaced in a way that is useful for diagnostics.