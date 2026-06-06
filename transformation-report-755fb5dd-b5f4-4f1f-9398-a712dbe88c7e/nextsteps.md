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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for their cross-platform equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Platform-Specific Code

Even without build errors, there may be runtime issues caused by APIs that existed in .NET Framework but behave differently or are unavailable in cross-platform .NET. Pay particular attention to:

- **`System.Web` dependencies** — These are not available in cross-platform .NET. Ensure `Bookstore.Web` has been fully migrated to ASP.NET Core equivalents.
- **Configuration** — Verify that `Web.config` or `App.config` usage has been replaced with `appsettings.json` and `IConfiguration`.
- **Authentication/Authorization** — Confirm that any membership or identity providers have been migrated to ASP.NET Core Identity or equivalent.
- **Entity Framework** — If the project uses Entity Framework, confirm it has been upgraded to Entity Framework Core and that migrations are compatible.

---

## 4. Run the Application Locally

Start the application locally to verify it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the key areas of the application and check the console output for any unhandled exceptions or warnings.

---

## 5. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results carefully. Failing tests may indicate behavioral differences between .NET Framework and cross-platform .NET that need to be addressed.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the data layer specifically:

- Confirm database connection strings are correctly configured in `appsettings.json`.
- If using Entity Framework Core, run any pending migrations against a development database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Verify that CRUD operations function correctly against the database.

---

## 7. Check Runtime Compatibility

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining API compatibility concerns that do not surface as build errors but may cause runtime failures.

```bash
dotnet tool install -g dotnet-apicompat
```

---

## 8. Review Logging and Error Handling

Confirm that logging has been migrated to `Microsoft.Extensions.Logging` or a compatible provider such as Serilog or NLog. Verify that error handling middleware is correctly configured in the ASP.NET Core pipeline within `Bookstore.Web`.