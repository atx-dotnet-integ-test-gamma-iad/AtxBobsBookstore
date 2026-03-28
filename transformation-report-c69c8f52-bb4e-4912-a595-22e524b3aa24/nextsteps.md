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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between them.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or packages may only function on Windows. Search the codebase for usages of the following:

- `Microsoft.Win32` namespaces
- `System.Windows.Forms` or `System.Drawing` (non-web)
- Any P/Invoke calls using `[DllImport]`
- Registry access (`RegistryKey`, etc.)

If any are found, evaluate whether a cross-platform alternative exists or whether a runtime guard (`OperatingSystem.IsWindows()`) is appropriate.

---

## 5. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that the data access configuration is compatible with the new runtime:

- If using **Entity Framework Core**, verify the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using **EF 6 (non-Core)**, note that EF 6 has limited cross-platform support and consider migrating to EF Core.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime exceptions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable) to confirm expected behavior.

---

## 7. Check Application Configuration

Review `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) to ensure:

- Connection strings are valid and point to the correct database instance.
- Any configuration values previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` entries.
- Secrets are not hardcoded; use `dotnet user-secrets` for local development sensitive values.

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your-connection-string"
```

---

## 8. Execute Unit and Integration Tests

If a test project exists in the solution, run the full test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced during the migration rather than pre-existing failures.

---

## 9. Validate Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) and confirm:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`).
- Static files, routing, and error handling middleware are configured appropriately for ASP.NET Core.
- Any legacy `HttpModule` or `HttpHandler` implementations from the old `System.Web` pipeline have been replaced with ASP.NET Core middleware equivalents.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target hosting environment (IIS, Linux server, Azure App Service, etc.), ensuring the runtime environment matches the target framework specified in the project file.