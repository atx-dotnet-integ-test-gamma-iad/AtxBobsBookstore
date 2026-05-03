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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net472` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some packages or APIs may only function correctly on Windows. Review the dependencies in each project for the following:

- Any package that includes `Windows` in its name or targets `windows` in its TFM
- Usage of `System.Web`, `System.Drawing`, or `Microsoft.Win32` namespaces
- Registry access, COM interop, or Windows-specific file paths

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC 5 project, confirm it has been migrated to ASP.NET Core and that all middleware, routing, and configuration patterns follow ASP.NET Core conventions.

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- The `DbContext` configuration has been updated to use `IServiceCollection` extension methods rather than `OnConfiguring` with a hardcoded connection string where applicable
- Run any pending migrations or verify the schema against the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 7. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- Application starts without exceptions
- Database connections are established successfully
- Core application routes and pages load correctly
- Any authentication or authorization middleware functions as expected

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Address Nullable Reference Type Warnings

If the projects have `<Nullable>enable</Nullable>` set, review any warnings about nullable reference types. While these do not cause build failures by default, resolving them improves code correctness and reduces the risk of null reference exceptions at runtime.