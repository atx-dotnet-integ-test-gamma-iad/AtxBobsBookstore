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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported release.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` registry access
- Windows-only file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls targeting Windows libraries

Use `Path.Combine` and `Path.DirectorySeparatorChar` for any file path handling to ensure cross-platform compatibility.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the data access configuration is compatible with cross-platform .NET. If Entity Framework is in use:

- Ensure you are using `Microsoft.EntityFrameworkCore` and not `System.Data.Entity` (the legacy EF6 namespace).
- Verify the database provider package (e.g., `Npgsql.EntityFrameworkCore.PostgreSQL`, `Microsoft.EntityFrameworkCore.SqlServer`) is present and up to date.
- Run any pending migrations to confirm the schema is in sync.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, user authentication if applicable) to confirm expected behavior.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are failing due to migration-related changes or pre-existing issues.

---

## 8. Inspect Configuration Files

Review `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) in `Bookstore.Web` to ensure:

- Connection strings are correct and use the appropriate format for the target database.
- Any configuration keys previously stored in `Web.config` have been moved to `appsettings.json`.
- Sensitive values such as connection strings or API keys are stored using the .NET Secret Manager or environment variables rather than being hardcoded.

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.