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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correct for the target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality works, including any pages or endpoints that interact with the database.

---

## 6. Review Configuration Files

Check the following configuration concerns:

- Ensure `appsettings.json` does not contain any Windows-specific paths or configuration values that would not be valid on Linux or macOS if cross-platform support is required.
- Confirm that any file I/O operations in the codebase use `Path.Combine` rather than hardcoded path separators.
- Review any authentication or session configuration that may have been handled differently in the legacy project.

---

## 7. Check for Removed or Changed APIs

Review the codebase for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET and should be replaced with ASP.NET Core equivalents.
- `HttpContext` usage patterns.
- Any use of `ConfigurationManager`, which should be replaced with `IConfiguration`.

Use the .NET Upgrade Assistant compatibility analyzer if a more thorough audit is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze Bookstore.Web
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.