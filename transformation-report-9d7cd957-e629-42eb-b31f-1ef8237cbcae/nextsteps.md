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

Since all projects compiled without errors, the following steps focus on validating and testing the migrated solution before deploying it.

---

## 1. Restore and Build the Solution

Run the following commands from the solution root to confirm a clean restore and build:

```bash
dotnet restore
dotnet build --configuration Release
```

Verify that no warnings or errors appear in the output. Pay attention to any deprecation warnings that may indicate future compatibility issues.

---

## 2. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x`, `net5.0`, or `net6.0`, update it to `net8.0` and re-run the build.

---

## 3. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas:

- **`System.Web` references**: These are not supported in .NET. If any remain, they need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`, `HttpRequest`, `HttpResponse`**: Ensure these are using the `Microsoft.AspNetCore.Http` namespace.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` if still in use.
- **`EntityFramework` (non-Core)**: If `Bookstore.Data` was using the classic `EntityFramework` NuGet package, it must be migrated to `Microsoft.EntityFrameworkCore`.

Run the following to list all packages across the solution:

```bash
dotnet list package
```

---

## 4. Run Unit Tests

If the solution contains a test project, run the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider adding one targeting `Bookstore.Domain` at minimum, as it is the most independent layer.

---

## 5. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are in place and the database schema is up to date.

Check for existing migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- Routing works as expected.
- Pages or API endpoints return correct responses.
- Database reads and writes function correctly.

Review the console output and any log files for runtime errors or warnings.

---

## 7. Review `appsettings.json` and Environment Configuration

Confirm that `appsettings.json` contains all required configuration keys, and that environment-specific files such as `appsettings.Production.json` are present and correct. Ensure no sensitive values such as connection strings or API keys are hardcoded in source files.

---

## 8. Address Any Remaining Warnings

After the build and test steps, revisit any compiler warnings. Common warnings after migration include:

- Nullable reference type warnings (`CS8600`, `CS8602`, `CS8603`)
- Obsolete API usage (`CS0618`)

These do not prevent the application from running but should be resolved to maintain code quality.