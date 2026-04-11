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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Check that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and test core functionality such as browsing, searching, and any data-driven pages.
- Check the console output for any runtime exceptions or middleware configuration warnings.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings, replacing any values that were previously stored in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are configured appropriately.

### 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that behave differently in cross-platform .NET compared to .NET Framework. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, WCF, or certain cryptography providers.
- Any use of `HttpContext` or session handling that may require updated middleware configuration in ASP.NET Core.

### 8. Publish the Application

Once validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.