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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Environment-specific configuration files such as `appsettings.Development.json` and `appsettings.Production.json` are present and correctly structured.
- Any configuration transforms that existed previously have been manually replicated in the appropriate `appsettings` files.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- If Entity Framework is used, verify that migrations are present and up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the application using the .NET CLI to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Development
```

- Navigate to the application in a browser and verify that core functionality works, including any pages that interact with the database through `Bookstore.Data` and `Bookstore.Domain`.
- Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

- Review test results for any failures that may indicate behavioral differences introduced during the migration.
- Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository or context behavior.

---

## 7. Validate Static Assets and Middleware (Bookstore.Web)

- Confirm that static files (CSS, JavaScript, images) are served correctly. In cross-platform .NET, static files must reside in the `wwwroot` folder.
- Review `Program.cs` or `Startup.cs` to ensure middleware is configured in the correct order, including authentication, routing, and static file middleware.
- If the project previously used `HttpModules` or `HttpHandlers`, confirm these have been replaced with the appropriate ASP.NET Core middleware.

---

## 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs that may cause issues on non-Windows environments:

- `System.Web` references should no longer be present.
- Registry access, Windows-specific file paths, or COM interop should be replaced or removed.
- Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific calls.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.