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

Verify that no warnings or errors appear during restoration, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the error-free state is consistent:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Database connection strings in configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework migrations are up to date. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

### 6. Review Configuration Files

Check that the following have been properly migrated from any legacy `Web.config` or `App.config` files to the appropriate `appsettings.json` structure:

- Connection strings
- Application settings keys
- Any environment-specific configuration values

### 7. Check for Runtime Compatibility Issues

Some APIs behave differently on cross-platform .NET compared to .NET Framework. Pay particular attention to:

- Any use of `System.Web` namespaces, which are not available on cross-platform .NET.
- Windows-specific APIs such as the registry, certain cryptography providers, or NTLM/Windows Authentication configurations.
- File path separators if the application constructs paths manually.

### 8. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element reflects the expected value, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid cross-framework reference issues.