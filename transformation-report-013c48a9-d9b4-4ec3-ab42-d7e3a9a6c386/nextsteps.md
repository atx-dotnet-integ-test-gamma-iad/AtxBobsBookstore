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

Check the output for any warnings that, while non-breaking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may have been introduced during the transformation.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following areas at a minimum:

- Application startup and homepage load
- Database connectivity from `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic in `Bookstore.Domain` exercised through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) to confirm that:

- Connection strings are valid and point to the correct database instances
- Any configuration keys that were previously in `Web.config` have been correctly migrated to the new configuration system

### 6. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that compile cross-platform but behave differently or fail at runtime on non-Windows systems. Review the code in all three projects for usage of:

- `System.Drawing` (GDI+)
- Windows registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Web` remnants that may have been shimmed

### 7. Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and can be applied to the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended modern .NET version (e.g., `net8.0`), and that no project is inadvertently still targeting `net48` or `netstandard2.0` where a newer target is appropriate.