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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `net5.0` or `net6.0`, update it to a supported long-term support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the codebase for any APIs or libraries that are Windows-only. Common examples include:

- `System.Web` (not available in cross-platform .NET)
- Windows Registry access
- `HttpContext` usage from `System.Web` rather than `Microsoft.AspNetCore.Http`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific code paths.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** is required for cross-platform .NET. The legacy `EntityFramework` (6.x) package is Windows-friendly but EF Core is preferred for new targets.

Run any pending migrations or verify the database schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests to determine whether failures are due to migration-related changes or pre-existing issues.

If no test projects currently exist, consider adding tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions
- Database connectivity is functional
- Core user-facing features (browsing, searching, purchasing books, etc.) behave as expected
- Configuration values such as connection strings are correctly loaded from `appsettings.json` rather than `Web.config`

---

## 8. Review Configuration Migration

Legacy .NET Framework projects use `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Confirm that:

- All connection strings have been moved to `appsettings.json`
- Any `<appSettings>` keys have been migrated to the appropriate `appsettings.json` structure
- Environment-specific overrides use `appsettings.Development.json` or environment variables

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.