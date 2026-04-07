# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during restoration, particularly around package version compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Pages and endpoints return correct responses.
- Any data access operations (reads and writes) function correctly through `Bookstore.Domain` and `Bookstore.Data`.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- **Configuration**: `System.Configuration` is not available in cross-platform .NET. Confirm that configuration has been migrated to `Microsoft.Extensions.Configuration` using `appsettings.json`.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm whether it has been migrated from EF 6 to EF Core and that migrations are functioning correctly.
- **HTTP and middleware**: If any custom HTTP modules or handlers existed in the legacy project, verify they have been replaced with the appropriate ASP.NET Core middleware.

### 7. Review Static Files and Views

If `Bookstore.Web` uses Razor views or serves static files, manually browse through the key pages to confirm rendering is correct and no missing assets or view compilation errors exist.

### 8. Database Migration Check

If Entity Framework Core is in use, verify that the database schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that all migrations have been applied and the schema matches expectations.

### 9. Publishing the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and assets are present before deploying to the target environment.