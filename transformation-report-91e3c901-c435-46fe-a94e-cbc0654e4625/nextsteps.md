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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the current .NET runtime, such as changes in:

- `System.Web` dependencies that were replaced
- Serialization behavior
- Globalization and encoding defaults

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that the database connection still functions correctly:

- Check that the connection string format in `appsettings.json` (or equivalent configuration file) is valid for the current provider.
- If Entity Framework is used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:

- Application startup and routing
- Authentication and authorization, if present
- Data retrieval and display from `Bookstore.Data`
- Any file I/O or static asset serving, as path handling differs between Windows and Linux/macOS

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`
- No legacy `<system.web>` or `<system.webServer>` configuration blocks remain in use

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs that may not function correctly on Linux or macOS:

- `Microsoft.Win32` namespace usage
- `System.Web` references
- Windows registry access
- Hardcoded Windows-style file paths using backslashes

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.