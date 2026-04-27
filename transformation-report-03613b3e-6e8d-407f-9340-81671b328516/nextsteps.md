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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output for any failures. Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.

### 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core or another ORM, verify that:

- The connection string in `appsettings.json` is correctly configured for your target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is appropriate for your target platform.

### 5. Run the Web Application Locally

Start the web application and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm that pages load correctly and data operations function as expected.

### 6. Review Platform-Specific Code

Even without build errors, inspect the codebase for any remaining platform-specific patterns that may cause runtime issues on non-Windows environments:

- File path construction using `\` instead of `Path.Combine`.
- Use of `System.Drawing` or other Windows-only libraries.
- Registry access or Windows-specific APIs.
- Absolute file paths referencing Windows drive letters.

### 7. Review Configuration and Middleware

In `Bookstore.Web`, confirm that the `Program.cs` and `Startup.cs` (if present) have been correctly updated to use the modern .NET hosting model. Verify that middleware registration and service configuration are functioning as expected.

### 8. Check Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-targeting issues.