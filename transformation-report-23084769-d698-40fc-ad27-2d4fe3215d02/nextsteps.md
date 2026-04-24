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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

If any project still references `net48` or another .NET Framework moniker, update it to the appropriate modern target.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Replace or remove these with cross-platform equivalents where applicable.

---

## 5. Inspect and Update `Bookstore.Data`

If `Bookstore.Data` uses Entity Framework, confirm it has been migrated from Entity Framework 6 (EF6) to Entity Framework Core (EF Core).

```bash
dotnet ef dbcontext info --project Bookstore.Data
```

Verify that:
- The `DbContext` class inherits from `Microsoft.EntityFrameworkCore.DbContext`
- Connection strings in `appsettings.json` are correctly configured
- Any existing migrations are compatible with EF Core

If migrations need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

---

## 6. Review `Bookstore.Web` Configuration

In .NET, `web.config` is replaced by `appsettings.json` and `Program.cs`/`Startup.cs`. Confirm the following:

- Application settings previously in `web.config` have been moved to `appsettings.json`
- Middleware is configured correctly in `Program.cs`
- Authentication, authorization, and routing are set up using the ASP.NET Core equivalents

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the reported local URL (e.g., `https://localhost:5001`) and manually verify that core functionality works as expected, including:

- Page rendering
- Database reads and writes
- Any authentication flows

---

## 8. Execute Existing Tests

If the solution contains a test project, run all tests to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.

---

## 9. Cross-Platform Validation

If cross-platform support is a requirement, run and test the application on a non-Windows operating system (Linux or macOS) to surface any remaining platform-specific issues that may not appear on Windows.