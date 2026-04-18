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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` sections.

### 3.2 Database Connectivity

- Confirm the connection string in `appsettings.json` points to a valid and accessible database instance.
- If the project uses Entity Framework, run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, consider generating an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application and verify it runs without runtime exceptions.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL (typically `https://localhost:5001` or `http://localhost:5000`).
- Exercise the primary workflows (browsing, searching, and any data entry flows) to confirm expected behavior.
- Review the console output and application logs for any unhandled exceptions or warnings.

---

## 5. Review and Run Existing Tests

If the solution contains a test project, run the tests to validate business logic and data access behavior.

```bash
dotnet test
```

- Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.
- Pay particular attention to tests that cover data access in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework changes.

---

## 6. Cross-Platform Validation

Since the goal of this transformation is cross-platform compatibility, verify the application runs correctly on each target operating system (Windows, Linux, macOS) if applicable.

- Pay attention to file path handling, as Windows-style paths (`\`) are not compatible with Linux/macOS. Use `Path.Combine` or forward slashes where paths are constructed in code.
- Confirm that any file I/O operations, such as reading static assets or writing logs, function correctly on non-Windows systems.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a newer LTS version of .NET is available and preferred, update the target framework accordingly and re-run the build and tests.

---

## 8. Publishing the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all necessary files are present.
- Verify that static assets, configuration files, and any required runtime dependencies are included in the output.