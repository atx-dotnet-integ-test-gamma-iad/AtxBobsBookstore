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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48`, `netcoreapp3.1`, or `net6.0`, update it to a current supported version.

---

## 4. Check for Removed or Changed APIs

Cross-platform .NET removes certain Windows-specific APIs that were available in .NET Framework. Review the code in each project for usage of:

- `System.Web` namespaces (not available in .NET Core/5+)
- `HttpContext` usage outside of ASP.NET Core patterns
- Windows Registry access (`Microsoft.Win32.Registry`)
- `AppDomain.CurrentDomain.BaseDirectory` alternatives if behavior has changed
- Any P/Invoke calls targeting Windows-only native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific code paths are needed.

---

## 5. Validate Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Migrations are present and up to date. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` project at minimum, as it represents the core business logic.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, adding to cart, etc.)
- Check the console output and application logs for any runtime exceptions
- Verify that database connections are established correctly using the connection string in `appsettings.json`

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains the correct values for the target environment:

- Connection strings
- Logging levels
- Any application-specific settings that were previously stored in `Web.config` or `App.config`

Note that `Web.config` is no longer the primary configuration mechanism in ASP.NET Core. Confirm all settings have been migrated to the `appsettings.json` pattern.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target host environment.