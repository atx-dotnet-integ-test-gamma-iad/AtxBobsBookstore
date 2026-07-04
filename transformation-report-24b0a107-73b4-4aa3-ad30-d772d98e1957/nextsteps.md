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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining dependencies that are Windows-specific. Common areas to check include:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET
- References to the Windows Registry (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows-only libraries
- Any remaining `packages.config` files that should have been migrated to `PackageReference`

---

## 5. Run Unit Tests

If the solution contains test projects, run them to validate that the core logic has not been affected by the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in `appsettings.json` is correct for the target environment
- If Entity Framework is used, run the following to verify the model is consistent with the database schema:

```bash
dotnet ef migrations list
```

If there are pending migrations or model mismatches, resolve them before proceeding.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core pages and features load correctly. Pay particular attention to:

- Authentication and authorization flows
- Database-driven pages
- Any file system operations that may rely on Windows-style paths

---

## 8. Review Configuration Files

Confirm that configuration has been properly migrated from `Web.config` or `App.config` to `appsettings.json`. Key areas to verify include:

- Connection strings
- Application settings
- Logging configuration
- Any environment-specific settings

---

## 9. Test on a Non-Windows Environment

Since the goal of the migration is cross-platform compatibility, validate the application on a Linux or macOS environment if possible:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

This will surface any remaining platform-specific issues that may not appear when running on Windows.