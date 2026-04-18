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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Runtime Dependencies

Some libraries that compiled successfully under .NET Framework may behave differently at runtime under cross-platform .NET. Pay particular attention to:

- **Entity Framework**: Confirm the correct version of EF Core is being used in `Bookstore.Data` and that migrations are compatible.
- **Configuration**: Verify that `appsettings.json` is present and correctly replaces any `Web.config` or `App.config` entries that were used previously.
- **Authentication/Authorization**: If any Windows Authentication or Forms Authentication was used in `Bookstore.Web`, confirm it has been replaced with the appropriate ASP.NET Core middleware.

---

## 4. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify:

- Pages load without HTTP 500 errors.
- Database connectivity is functional.
- Any authentication flows work as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests currently exist, consider writing tests that cover:

- Core domain logic in `Bookstore.Domain`
- Data access methods in `Bookstore.Data`
- Key controller actions or Razor pages in `Bookstore.Web`

---

## 7. Verify Cross-Platform Behavior

Since the goal of the transformation was cross-platform compatibility, test the application on a non-Windows environment if possible (Linux or macOS). Common issues to check for include:

- **File path separators**: Ensure no hardcoded backslashes (`\`) are used in file paths. Use `Path.Combine()` instead.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs**: Check for any remaining usage of Windows registry, COM interop, or Windows-only libraries that may have been missed during transformation.

---

## 8. Review Logging and Error Handling

Confirm that logging is configured correctly using the built-in `Microsoft.Extensions.Logging` infrastructure or a compatible provider such as Serilog or NLog. Verify that unhandled exceptions are captured and surfaced appropriately in both development and production environments.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.