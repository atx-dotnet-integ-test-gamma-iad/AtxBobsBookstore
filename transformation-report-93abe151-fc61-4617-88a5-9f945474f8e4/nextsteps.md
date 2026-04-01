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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org/).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any environment-specific configuration is handled using the `IConfiguration` / `IOptions<T>` pattern rather than `ConfigurationManager`.

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is the correct version for your target .NET runtime.

---

## 5. Run Unit and Integration Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration (e.g., changes in serialization, encoding, or culture defaults between .NET Framework and modern .NET).

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web
```

Verify the following:
- All pages and routes load correctly.
- Authentication and authorization behave as expected.
- Database reads and writes function correctly.
- Any file I/O or path-handling logic works correctly on the target OS, since path separators differ between Windows and Linux/macOS.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining usage of Windows-specific APIs that may not be available cross-platform:

- `System.Web` references (should have been removed)
- `Registry` access (`Microsoft.Win32.Registry`)
- Windows-only authentication mechanisms (e.g., NTLM/Windows Authentication) — ensure these are intentional if present
- `System.Drawing` — replace with a cross-platform alternative such as `SkiaSharp` if image processing is required

---

## 8. Publish the Application

Once local validation is complete, publish the application for your target environment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target server.