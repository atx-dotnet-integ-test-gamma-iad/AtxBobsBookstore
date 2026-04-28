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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still referenced, replace them with their .NET-compatible equivalents via [NuGet](https://www.nuget.org/).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns, such as obsolete API usage.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic, verify the following:

- If using **Entity Framework Core**, confirm that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using a different ORM or raw ADO.NET, verify that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality through the browser.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- Pages load and render correctly.
- Data is read from and written to the database as expected.
- Authentication and authorization flows work correctly, if applicable.

---

## 7. Review Configuration Files

Confirm that `appsettings.json` and `appsettings.Production.json` contain all required configuration values, including:

- Database connection strings
- Any API keys or external service endpoints
- Logging configuration

Sensitive values should not be stored in source control. Use environment variables or a secrets manager for production configuration.

---

## 8. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or dependencies that may cause issues on Linux or macOS if cross-platform deployment is intended.

Common areas to check:

- Use of `System.Windows` or `Microsoft.Win32` namespaces
- Windows registry access
- File path separators (use `Path.Combine` rather than hardcoded backslashes)

---

## 9. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.