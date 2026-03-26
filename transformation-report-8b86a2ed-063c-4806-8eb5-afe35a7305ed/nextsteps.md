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

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests covering the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- The database can be updated successfully:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new framework:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 7. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the JSON-based configuration system.

### 8. Check for Windows-Specific API Usage

Even without build errors, the code may reference APIs that compile successfully but fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface any such issues:

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Additionally, review the code manually for usages of `System.Web`, Windows registry access, or Windows-specific file path assumptions.

### 9. Test on the Target Platform

If the intended deployment platform is Linux or macOS, run and test the application on that operating system to catch any runtime issues that would not surface on Windows.