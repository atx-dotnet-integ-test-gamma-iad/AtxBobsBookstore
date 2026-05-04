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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a deliberate reason.

### 4. Check for Windows-Specific APIs

Even without build errors, the code may contain calls to Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any resulting analyzer warnings, particularly in `Bookstore.Data` where database or file system access is likely to reside.

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are valid and accessible in the new environment.
- Run any pending migrations to confirm the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify it loads and functions as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the key areas of the application and confirm that pages render correctly and data operations function as intended.

### 8. Review `Program.cs` and Startup Configuration

If the project was migrated from ASP.NET MVC (.NET Framework), confirm that the legacy `Startup.cs` and `Global.asax` patterns have been correctly replaced with the modern `Program.cs` minimal hosting model. Verify that all middleware, services, and routing are registered correctly.

### 9. Check Static Files and Bundling

If the application uses static assets, confirm that `wwwroot` is structured correctly and that any bundling or minification previously handled by `BundleConfig.cs` or `System.Web.Optimization` has been replaced with a supported alternative such as `LibMan` or a front-end build tool.