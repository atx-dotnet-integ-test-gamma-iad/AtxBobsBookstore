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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access
- COM interop
- `HttpContext.Current` (not available in ASP.NET Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version being used is Entity Framework Core and not the legacy `System.Data.Entity` namespace.

```bash
dotnet ef dbcontext info --project app/Bookstore.Data
```

- Verify that migrations exist and are up to date.
- Run a migration if needed:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify that existing functionality is preserved after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, such as changes in serialization, globalization, or HTTP handling.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the following areas specifically:

- Application startup and middleware configuration in `Program.cs`
- Database connectivity
- Authentication and authorization behavior, if applicable
- Static file serving
- Any configuration values previously stored in `Web.config` that should now be in `appsettings.json`

---

## 8. Validate Configuration Migration

Ensure that all values previously in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables. Key areas include:

- Connection strings
- Application settings
- Custom configuration sections

Example `appsettings.json` structure:

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

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.