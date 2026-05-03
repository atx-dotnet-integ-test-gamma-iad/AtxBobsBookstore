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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any NuGet packages or APIs that are Windows-only. Common examples include:

- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- COM interop

Replace or remove any such dependencies with cross-platform equivalents.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core provider is referenced and that any pending migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider adding tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all required configuration values, including connection strings, and that `appsettings.Development.json` is appropriate for local use. Ensure secrets are not committed to source control; use `dotnet user-secrets` for local development.

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.