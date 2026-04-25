# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- **Database provider**: Ensure the configured database provider (e.g., SQL Server, SQLite) is compatible with the target .NET version.
- **Connection strings**: Verify that connection strings in `appsettings.json` or environment variables are correctly configured for the target environment.
- **Migrations**: If Entity Framework Core is in use, confirm that existing migrations are intact and apply them to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Data is read from and written to the database correctly.
- Any authentication or authorization mechanisms function properly.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from .NET Framework. Verify the following:

- `Web.config` transformations have been replaced with `appsettings.json` and `appsettings.{Environment}.json` where applicable.
- Any settings previously stored in `Web.config` (e.g., app settings, connection strings) have been migrated to the appropriate configuration files.
- Environment-specific settings are correctly separated.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Upgrade Assistant compatibility analyzer or the Platform Compatibility Analyzer to identify any remaining Windows-specific or framework-specific API calls that may cause issues on non-Windows platforms:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Pay particular attention to any APIs flagged with `[SupportedOSPlatform]` attributes, as these may not behave correctly outside of Windows environments.

---

## 8. Validate Static Assets and Middleware

For `Bookstore.Web`, confirm that:

- Static files (CSS, JavaScript, images) are served correctly via the `UseStaticFiles()` middleware.
- Any HTTP handlers or modules from the original `Web.config` have been replaced with the equivalent ASP.NET Core middleware in `Program.cs` or `Startup.cs`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and assets are present before deploying to the target environment.