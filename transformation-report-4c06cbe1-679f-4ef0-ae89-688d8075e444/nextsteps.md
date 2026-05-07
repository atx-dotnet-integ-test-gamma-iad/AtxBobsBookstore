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

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless intentionally required.

### 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet package references and code for any APIs or libraries that are Windows-specific. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- COM interop or P/Invoke calls targeting Windows-only system libraries
- Any packages with a `-windows` target framework suffix that may not be needed

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and the new target framework.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the primary user-facing features, including:

- Page rendering and navigation
- Data access operations through `Bookstore.Data`
- Any domain logic exercised through `Bookstore.Domain`

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, confirm that:

- The connection string is correctly configured for the new environment
- Any pending migrations are applied using:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

### 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are present and correctly structured. If the original project used `Web.config`, verify that all relevant settings have been migrated to the new configuration system.

### 9. Address Any Compiler Warnings

While warnings do not prevent a build, they can indicate deprecated API usage or potential runtime issues. Review the build output and address warnings where practical, particularly those flagged as obsolete APIs or nullable reference type mismatches if nullable context is enabled.