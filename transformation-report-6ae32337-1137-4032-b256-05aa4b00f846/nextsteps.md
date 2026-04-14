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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., APIs not available on Linux/macOS)

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48` or `netstandard2.0`, consider updating it to align with the rest of the solution.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that the data access layer is functioning correctly:

- If using **Entity Framework Core**, verify the correct EF Core packages are referenced (e.g., `Microsoft.EntityFrameworkCore`, the appropriate database provider).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If connection strings were previously stored in `Web.config`, ensure they have been moved to `appsettings.json` in `Bookstore.Web`.

---

## 5. Check Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all necessary configuration that was previously in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the core functionality of the application.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 8. Cross-Platform Validation

If cross-platform support is a goal, run the application on Linux or macOS (or within a non-Windows environment) to identify any remaining platform-specific dependencies, such as:

- Windows Registry access
- `System.Drawing.Common` usage (not supported on non-Windows without additional configuration)
- Windows-specific file path assumptions

---

## 9. Publish the Application

Once validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.