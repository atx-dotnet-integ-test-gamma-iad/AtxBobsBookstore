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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Confirm that any configuration previously held in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` structure or the `IConfiguration` system.

---

## 4. Verify Database Connectivity (Bookstore.Data)

- Confirm that the connection string in `appsettings.json` points to the correct database instance.
- If Entity Framework Core is in use, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it loads without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Walk through the core user flows (e.g., browsing books, adding to cart, placing an order) to confirm that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` are functioning correctly.
- Check the console and any configured logging output for unhandled exceptions or warnings.

---

## 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw at runtime on the target platform. Review the following areas:

- File system path handling — ensure `Path.Combine` is used rather than hardcoded separators.
- Any use of the Windows registry, COM interop, or `System.Drawing` (GDI+), which may not be supported on Linux or macOS without additional packages.
- Cryptography or security APIs that previously relied on Windows-specific providers.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate correctness after migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and the new .NET runtime rather than pre-existing bugs.

---

## 8. Validate Publish Output

Produce a published build to confirm the output is complete and self-consistent.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required assets, static files, and configuration files are present.

---

## 9. Smoke Test the Published Output

Run the published output directly to confirm it behaves the same as the development run.

```bash
dotnet ./publish/Bookstore.Web.dll
```

Repeat the core user flow checks described in Step 5 against this published build.