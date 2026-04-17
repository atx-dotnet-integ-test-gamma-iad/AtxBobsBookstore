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

Perform a full solution build to confirm there are no build-time issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors, particularly around nullable reference types, obsolete APIs, or framework-specific code paths that may have been silently carried over.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Pay attention to any tests that were previously passing on the legacy framework but now fail due to behavioral differences in .NET, such as changes in `System.Text.Json` vs `Newtonsoft.Json`, differences in `HttpClient` behavior, or changes in Entity Framework Core semantics.

### 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- Entity Framework Core migrations are present and up to date. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- All pages load without runtime exceptions.
- Database read and write operations function correctly.
- Any authentication or session-based functionality behaves as expected under ASP.NET Core.
- Static files, bundling, and routing are functioning correctly.

### 6. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) contain all required configuration values that were previously held in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Any custom application settings

### 7. Check for Platform-Specific Code

Search the solution for any remaining usage of Windows-specific APIs or packages that may not behave correctly on Linux or macOS if cross-platform support is a requirement:

```bash
grep -rn "System.Web" ./app
grep -rn "Registry" ./app
grep -rn "WindowsIdentity" ./app
```

Replace or conditionally compile any findings that are not compatible with the target platforms.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework reference issues.