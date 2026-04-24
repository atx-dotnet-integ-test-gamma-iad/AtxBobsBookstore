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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their cross-platform equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform version of .NET (e.g., `net8.0`):

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

Example of a correct entry:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies on Windows-specific libraries or APIs. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Identity** (`System.Security.Principal.Windows`)
- **Windows-only NuGet packages**

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific calls.

---

## 5. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access technology has been migrated correctly:

- If using **Entity Framework**, ensure it has been updated to **Entity Framework Core**.
- Verify that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and configured.
- Run any pending migrations or verify the migration history is intact:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- Application starts without exceptions
- Database connectivity is functional
- Core application routes and pages load correctly
- Any configuration values (connection strings, app settings) are correctly read from `appsettings.json` rather than `web.config` or `app.config`

---

## 8. Review Configuration Migration

Confirm that configuration previously held in `web.config` has been moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Authentication or authorization configuration

Example `appsettings.json` structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 9. Publish the Application

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.