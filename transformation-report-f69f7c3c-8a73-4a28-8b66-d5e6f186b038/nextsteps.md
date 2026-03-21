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

The steps below describe how to validate, test, and deploy the migrated solution.

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

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- **Database provider**: Verify that the correct cross-platform compatible NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, or `Microsoft.EntityFrameworkCore.Sqlite`).
- **Connection strings**: Confirm that connection strings in `appsettings.json` or `appsettings.Development.json` are valid for your target environment.
- **Migrations**: If Entity Framework Core is used, verify that existing migrations are intact and apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- Pages or API endpoints load and return expected results.
- Database reads and writes function correctly.
- Any authentication or authorization flows behave as expected.

---

## 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older or out-of-support version is present (e.g., `net6.0`, `net7.0`), consider updating to the latest Long-Term Support (LTS) release.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Review the code for any usage of the following and replace or remove as needed:

- `System.Web` namespaces (replaced by `Microsoft.AspNetCore`)
- `HttpContext.Current`
- Windows Registry access
- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if image processing is required)

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can help identify remaining compatibility issues.

---

## 8. Validate Configuration System

.NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- Configuration has been migrated to `appsettings.json`.
- Environment-specific overrides use `appsettings.{Environment}.json`.
- Secrets are managed via the .NET Secret Manager or environment variables rather than being stored in configuration files.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to your target hosting environment.