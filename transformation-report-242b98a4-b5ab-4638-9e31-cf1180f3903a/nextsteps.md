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
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are either out of support or approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-specific APIs remain in use. Run the .NET Compatibility Analyzer if not already applied:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available on cross-platform .NET)
- Windows Registry access
- Windows-only file path assumptions (e.g., backslashes)
- Any P/Invoke calls targeting Windows-only native libraries

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the correct EF Core package is referenced rather than the legacy `EntityFramework` (EF6) package.

```bash
dotnet ef dbcontext info
```

Run any pending migrations to verify the database schema is in a valid state:

```bash
dotnet ef database update
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate
```

---

## 6. Run the Application Locally

Start the web application to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, including any pages or endpoints that interact with the data layer.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm expected behavior is preserved after migration:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET that require code adjustments.

---

## 8. Verify Configuration

Cross-platform .NET uses `appsettings.json` for configuration rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings are present in `appsettings.json`
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`
- No critical configuration remains only in a legacy `.config` file

---

## 9. Test on Target Operating Systems

If cross-platform support is a goal, test the application on each intended operating system (e.g., Linux, macOS) to surface any remaining platform-specific issues that would not appear when building on Windows.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```