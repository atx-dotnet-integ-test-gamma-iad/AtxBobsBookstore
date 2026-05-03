# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below cover how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

### Check for Windows-Specific APIs
Even if the project builds successfully, certain APIs used in `Bookstore.Web` or `Bookstore.Data` may only function on Windows. Use the .NET Compatibility Analyzer to identify these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any `CA1416` platform compatibility warnings that appear after adding this analyzer.

### Review `Bookstore.Data` for Database Compatibility
- Confirm that the database provider (e.g., Entity Framework Core) is configured correctly for cross-platform use.
- If the project previously used `System.Data.SqlClient`, ensure it has been migrated to `Microsoft.Data.SqlClient`.
- Run any pending Entity Framework migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that business logic and data access behavior remain correct after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing unit tests for critical paths in `Bookstore.Domain` and integration tests for `Bookstore.Data` before proceeding to deployment.

---

## 5. Validate the Web Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and confirm that all pages load correctly.
- Test any forms, data submissions, and database read/write operations.
- Check the application logs for runtime exceptions that would not have surfaced during the build.

### Configuration Files
- Confirm that `appsettings.json` contains the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or environment variables.

---

## 6. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 7. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.