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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any remaining references to Windows-specific packages or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Any package marked with the `windows` target framework moniker (e.g., `net8.0-windows`)

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC project targeting the full .NET Framework, confirm it has been migrated to ASP.NET Core and that no `System.Web` references remain.

### 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one to cover core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 6. Run the Application Locally

Start the web application to verify it runs correctly on the local machine:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the URL printed in the console output and verify that the core application functionality, such as browsing, searching, and any data-driven pages, works as expected.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If migrating from Entity Framework 6, confirm the migration to Entity Framework Core was completed and that all `DbContext` configurations are compatible.

### 8. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been moved to `appsettings.json` or `appsettings.{Environment}.json`, as the `System.Configuration` model is not used in cross-platform .NET.

### 9. Test on a Non-Windows Platform (Optional but Recommended)

To fully validate cross-platform compatibility, run the application on Linux or macOS if the target deployment environment is non-Windows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Observe any runtime exceptions that may surface from platform-specific code paths that were not caught at compile time.