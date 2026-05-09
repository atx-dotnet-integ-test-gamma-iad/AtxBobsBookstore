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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows `Build succeeded` with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from .NET Framework that are not fully supported cross-platform. Run the .NET Compatibility Analyzer to surface any such issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Pay particular attention to `Bookstore.Data` if it uses any database access libraries (e.g., Entity Framework), and `Bookstore.Web` if it uses any middleware or HTTP modules that were specific to `System.Web`.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) matches the version of EF Core being used.

---

## 7. Run the Web Application Locally

Start the application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages and features load without errors. Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay attention to:

- Connection strings
- Application-specific keys
- Authentication or authorization settings

---

## 9. Test on Target Platforms

Since the goal of the migration is cross-platform support, run the application on each intended target operating system (e.g., Linux, macOS) to confirm there are no platform-specific runtime issues:

```bash
dotnet run --project Bookstore.Web
```

Address any file path casing issues, OS-specific APIs, or missing runtime dependencies that surface during this step.

---

## 10. Publish the Application

Once validation is complete, publish the application for the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target server.