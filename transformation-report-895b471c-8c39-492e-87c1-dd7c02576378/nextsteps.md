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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Verify that database migrations are compatible with the new EF Core version.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm it has been migrated to ASP.NET Core. Check that middleware configuration in `Program.cs` or `Startup.cs` is correct.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs still behave as expected under the new runtime.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate that business logic and data access behavior remain correct.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs correctly end-to-end.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Perform the following manual checks:

- The application starts without runtime exceptions.
- Pages load and render correctly.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Any authentication or authorization flows work as expected.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common items to verify include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 9. Deploy to Target Environment

Copy the published output to your target server or hosting environment. Ensure the target machine has the correct .NET runtime installed.

```bash
dotnet --list-runtimes
```

The runtime version should match or be compatible with the `TargetFramework` specified in `Bookstore.Web.csproj`. If the runtime is not installed, download it from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).