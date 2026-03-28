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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Verify that database migrations are still valid by running:
  ```bash
  dotnet ef migrations list --project Bookstore.Data
  ```
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm it has been migrated to ASP.NET Core. Check `Program.cs` and `Startup.cs` (or the combined `Program.cs` in .NET 6+) for correct service registration and middleware configuration.
- **`Bookstore.Domain`**: Confirm that any serialization, reflection, or configuration-related code functions as expected under the new runtime.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify business logic and data access behavior remain correct.

```bash
dotnet test
```

If no test projects currently exist, consider adding tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before deploying.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the main workflows, including any database reads and writes, to confirm end-to-end functionality.

---

## 7. Review Configuration Files

Check `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) to ensure:

- Connection strings are correct and accessible from the new runtime environment.
- Any configuration keys previously stored in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables.
- The `Web.config` file, if still present, is only used for IIS hosting settings and not for application configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.