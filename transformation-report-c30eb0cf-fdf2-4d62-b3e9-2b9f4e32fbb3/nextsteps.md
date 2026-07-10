# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

Perform a full solution build to confirm there are no issues beyond what the error report captured:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior is preserved after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the data layer connects correctly to the target database:

- Check the connection string in `appsettings.json` (or `appsettings.Development.json`) within `Bookstore.Web`.
- If Entity Framework Core is being used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project was migrated from Entity Framework 6, confirm that EF Core equivalents for any previously used features (e.g., lazy loading, complex type mappings) are properly configured.

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that core functionality works end to end.
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration and Middleware

Cross-platform .NET handles configuration and middleware differently from legacy ASP.NET. Verify the following in `Bookstore.Web`:

- `Program.cs` and/or `Startup.cs` are correctly structured for the target .NET version.
- Authentication, authorization, and session middleware are configured properly.
- Static file paths use `Path.Combine` or equivalent cross-platform path handling rather than hardcoded backslashes.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or dependencies that may not behave correctly on Linux or macOS:

- Registry access (`Microsoft.Win32`)
- Windows-specific file path assumptions
- COM interop or P/Invoke calls

Replace these with cross-platform alternatives where applicable.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.