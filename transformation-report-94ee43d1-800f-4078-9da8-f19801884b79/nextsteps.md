# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

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

Check the output for any warnings that, while non-blocking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target .NET version.

### 5. Run the Web Application Locally

Start the application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually test the primary workflows, such as browsing, searching, and any authentication flows if present.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Development.json` contain all settings previously held in `Web.config` or `App.config`.
- Verify that any custom HTTP handlers, modules, or `Global.asax` logic has been properly migrated to ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

### 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs that may not be available on Linux or macOS if cross-platform deployment is intended:

```bash
grep -rn "Registry\|System.Web\|HttpContext.Current" --include="*.cs"
```

Address any findings by replacing them with cross-platform equivalents.

### 8. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid inter-project compatibility issues.