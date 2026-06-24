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

- Verify that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct configuration values.
- If the original project used `Web.config` or `App.config`, confirm that all relevant settings (connection strings, app settings, etc.) have been migrated to the appropriate `appsettings.json` sections.
- Check that the connection string in `appsettings.json` points to the correct database instance.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the following:

- If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If a different ORM or raw ADO.NET is used, manually verify that connection handling and query logic are compatible with the target .NET version.

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary user flows (browsing books, searching, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were Windows-specific in the original .NET Framework project and may not behave correctly cross-platform:

- `System.Web` references (should have been replaced by ASP.NET Core equivalents)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (backslashes, drive letters)
- COM interop or P/Invoke calls targeting Windows DLLs

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining issues if needed.

---

## 7. Execute Tests

If the solution contains test projects, run them to validate correctness after migration.

```bash
dotnet test
```

Review any failing tests to determine whether they indicate a genuine regression or a test that requires updating due to API changes in the new .NET version.

If no automated tests exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding to deployment.

---

## 8. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` folder to confirm all required files are present.
- Ensure the target hosting environment (IIS, Linux server, etc.) has the correct .NET runtime version installed that matches the target framework of the project.
- If deploying to IIS, confirm that the ASP.NET Core Hosting Bundle is installed and that the application pool is set to **No Managed Code**.