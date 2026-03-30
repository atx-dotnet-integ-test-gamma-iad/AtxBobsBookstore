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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related ASP.NET types in `Bookstore.Web`
- Any use of `AppDomain`, `BinaryFormatter`, or `Remoting` APIs
- Entity Framework version compatibility in `Bookstore.Data`

### 6. Run the Application Locally

Start the application locally to validate runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, searching, and any data access features work as expected.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, confirm that:

- The connection string is correctly configured for the target environment
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values that may have previously resided in `Web.config` or `App.config`. Key areas to check include:

- Connection strings
- Logging configuration
- Application-specific settings

### 9. Check Static Assets and Middleware

In `Bookstore.Web`, verify that static files, routing, and middleware are configured correctly in `Program.cs` or `Startup.cs`, particularly if the project was migrated from ASP.NET MVC to ASP.NET Core MVC.