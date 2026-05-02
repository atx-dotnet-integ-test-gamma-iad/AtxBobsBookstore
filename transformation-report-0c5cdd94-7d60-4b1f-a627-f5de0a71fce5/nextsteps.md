# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` (not available in cross-platform .NET)
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies with cross-platform equivalents.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access technology in use is compatible with cross-platform .NET:

- If using **Entity Framework 6**, migrate to **Entity Framework Core**.
- Verify the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and configured correctly.
- Run any pending migrations or verify the database schema is up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution includes a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing tests that cover:

- Domain model validation (`Bookstore.Domain`)
- Repository or data access methods (`Bookstore.Data`)
- Controller actions or Razor page handlers (`Bookstore.Web`)

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify:

- Pages load without errors
- Data is read from and written to the database correctly
- Authentication and authorization behave as expected, if applicable

---

## 8. Review `appsettings.json` Configuration

Confirm that `appsettings.json` and `appsettings.Production.json` contain the correct configuration values, including:

- Connection strings
- Logging settings
- Any application-specific configuration keys that were previously stored in `Web.config`

Ensure sensitive values are not committed to source control. Use environment variables or a secrets manager for production credentials.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.