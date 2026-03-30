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

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify the data layer specifically:

- Confirm that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to a development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser.
- Test any database-driven pages to confirm the data layer is functioning correctly.
- Check the console output and application logs for runtime exceptions that would not surface during a build.

### 6. Review `appsettings.json` and Configuration

Cross-platform .NET no longer reads from `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment variables.
- Any configuration previously stored in `Web.config` (such as app settings or custom sections) has been migrated to the appropriate `appsettings.json` structure.
- The `Startup.cs` or `Program.cs` file correctly wires up configuration sources.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unsupported on non-Windows platforms. If cross-platform deployment is intended:

- Search the codebase for usages of `System.Drawing`, `Microsoft.Win32`, or Windows registry access.
- Review any file path handling to ensure `Path.Combine` is used rather than hardcoded backslashes.

### 8. Review Publish Output

Before deploying, produce a publish output and inspect it:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify that all expected static assets, views, and configuration files are present in the output directory.