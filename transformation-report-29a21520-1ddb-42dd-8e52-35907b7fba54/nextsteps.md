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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Pay attention to:
- Any tests that were previously passing but now fail after migration.
- Tests that rely on Windows-specific behavior (e.g., file paths, registry access, COM interop).

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correct and use a supported format for your target database provider.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema matches the expected state after migration.

---

## 5. Validate Runtime Behavior of Bookstore.Web

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- All routes and pages load correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 6. Review Platform-Specific Code

Search the codebase for any APIs or patterns that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` references (should have been replaced during transformation).
- `HttpContext` usage outside of the request pipeline.
- Windows-specific APIs such as the registry, WMI, or NTLM authentication.
- `BinaryFormatter` usage, which is disabled by default in modern .NET.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining issues.

---

## 7. Review Configuration Migration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly moved to `appsettings.json` or environment-specific configuration files:

- Connection strings
- Application settings
- Logging configuration
- Any custom configuration sections

---

## 8. Test on Target Platform

If the goal is cross-platform deployment, test the application on the intended target operating system (e.g., Linux) to surface any remaining platform-specific issues:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then run the published output on the target machine and verify behavior matches the Windows development environment.