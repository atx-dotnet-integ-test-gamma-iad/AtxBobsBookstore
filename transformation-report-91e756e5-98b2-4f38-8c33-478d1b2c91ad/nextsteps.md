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

Run a NuGet package restore to confirm all dependencies resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or `net4x` targets exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility analyzers (e.g., `CA1416`).

---

## 3. Review Configuration Files

### `appsettings.json`
- Confirm that connection strings, API keys, and environment-specific settings have been correctly migrated from any legacy `Web.config` or `App.config` files.
- Ensure `appsettings.Development.json` and `appsettings.Production.json` are present and correctly structured.

### `Program.cs` / `Startup.cs`
- Verify that middleware registration, dependency injection setup, and service configuration reflect the intended behavior of the original application.

---

## 4. Database Validation (`Bookstore.Data`)

If the project uses Entity Framework, verify the data layer is functioning correctly.

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are used, confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences introduced by the framework migration rather than pre-existing bugs.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining calls to Windows-only or otherwise platform-restricted APIs.

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to diagnostics prefixed with `CA1416` (platform compatibility) and `SYSLIB` (obsolete or replaced APIs).

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.