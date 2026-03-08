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

Check the output for any warnings that, while non-breaking, may indicate areas that need attention (e.g., obsolete API usage, nullable reference warnings).

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether the failure is due to a behavioral difference introduced by the migration.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that the data layer is functioning correctly:

- Confirm that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and confirm that pages load correctly.
- Exercise key workflows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for runtime exceptions or configuration errors.

### 6. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm:

- Connection strings are valid and point to the correct database.
- Any configuration keys that were previously in `Web.config` have been correctly migrated to the new `appsettings.json` format.
- Environment-specific settings are correctly separated.

### 7. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

### 8. Review Removed Windows-Specific Dependencies

Confirm that no Windows-specific APIs or packages remain in use that would prevent the application from running on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- Registry access
- Windows-specific authentication providers
- `System.Drawing.Common` (which has platform restrictions in .NET 6+)