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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects — `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` — build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48` or another legacy framework, update it accordingly and re-run `dotnet restore` and `dotnet build`.

---

## 4. Check for Platform-Specific APIs

Search the codebase for APIs that may have been available in .NET Framework but are absent or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references (not available in .NET Core/5+)
- `HttpContext` usage outside of ASP.NET Core's dependency injection
- Windows Registry access (`Microsoft.Win32.Registry`)
- `AppDomain` usage
- `BinaryFormatter` (deprecated and disabled by default)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility issues.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before deploying.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- Application starts without runtime exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json`)
- Core user-facing pages and API endpoints respond correctly
- Authentication and authorization flows behave as expected

---

## 7. Review Configuration Files

Ensure that configuration has been migrated from `Web.config` or `App.config` to `appsettings.json` and `appsettings.{Environment}.json` as appropriate.

- Connection strings should be in `appsettings.json` under `"ConnectionStrings"`
- Environment-specific settings should use the appropriate environment file or environment variables
- Secrets should not be stored in source-controlled config files; use the [Secret Manager tool](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development

---

## 8. Verify Database Migrations

If the project uses Entity Framework, confirm that migrations are compatible with the new version of EF Core.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or inconsistent, generate a new migration to reflect the current model state.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations to the target database before deploying.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.