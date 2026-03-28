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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-specific APIs or libraries remain in the codebase. Common areas to check include:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-only NuGet packages
- Any `[SupportedOSPlatform("windows")]` warnings emitted during the build

Run the following to surface platform compatibility analyzer warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project locally to verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and manually verify that core functionality such as browsing, data retrieval, and any forms operate correctly.

---

## 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was migrated from Entity Framework 6, confirm that the migration to Entity Framework Core is complete and that all `DbContext` configurations, model relationships, and queries are functioning correctly.

---

## 7. Execute Automated Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to actual regressions or test configurations that need to be updated for the new runtime.

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.