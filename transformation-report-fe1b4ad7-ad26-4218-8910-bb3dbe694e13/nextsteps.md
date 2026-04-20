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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference old `net4x` target frameworks, consider finding their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that only function on Windows. Run the .NET Compatibility Analyzer to surface any such issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain intact after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` before proceeding further.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Entity Framework Core**: If the project uses EF Core, confirm the correct provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- **Connection Strings**: Ensure connection strings in `appsettings.json` are correctly configured and not still referencing legacy `Web.config` or `App.config` entries.
- **Migrations**: If using EF Core migrations, verify existing migrations are compatible and apply cleanly.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality such as navigation, data retrieval, and form submissions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions or middleware configuration errors that would not surface at compile time.

---

## 8. Review `Program.cs` and Middleware Configuration

ASP.NET Core applications configure services and middleware in `Program.cs`. Confirm that:

- Authentication and authorization middleware is registered if the legacy app used it.
- Static files middleware is present if the app serves CSS, JavaScript, or images.
- Any custom HTTP modules or handlers from the legacy app have been converted to ASP.NET Core middleware.

---

## 9. Validate Configuration Migration

Confirm that all settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or environment variables.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=Bookstore;..."
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is clean and self-contained.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.