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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Web.Infrastructure`
- `System.Web.*` namespaces
- `System.Drawing` (without the `System.Drawing.Common` NuGet package)
- Any P/Invoke calls targeting Windows-only DLLs

Replace or remove any such dependencies as needed.

---

## 5. Review Configuration and Middleware

In `Bookstore.Web`, verify that the application configuration has been fully migrated from `Web.config` to the ASP.NET Core model:

- Connection strings should be in `appsettings.json`
- Application settings should be accessed via `IConfiguration`
- Middleware should be registered in `Program.cs` using the `WebApplication` builder pattern

Confirm that no `Web.config` or `Global.asax` files are being relied upon at runtime.

---

## 6. Validate Database Connectivity

In `Bookstore.Data`, confirm that the data access layer is functioning correctly:

- If using Entity Framework Core, verify the `DbContext` is registered via dependency injection in `Program.cs`
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm the connection string in `appsettings.json` points to a reachable database instance

---

## 7. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 8. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 9. Cross-Platform Validation

If cross-platform support is a requirement, run the application on a non-Windows operating system (Linux or macOS) to confirm there are no runtime dependencies on Windows-specific behavior, such as:

- File path separators (use `Path.Combine` rather than hardcoded `\`)
- Registry access
- Windows Authentication (if not intentionally used)

---

## 10. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to the target server or hosting environment.