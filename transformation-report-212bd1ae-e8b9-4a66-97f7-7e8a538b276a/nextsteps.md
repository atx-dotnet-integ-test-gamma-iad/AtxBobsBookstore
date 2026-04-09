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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, consider updating them to versions compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that are Windows-only. Review the code in each project for usage of:

- `Microsoft.Win32` namespaces
- `System.Windows.Forms` or `System.Drawing` (non-web-safe versions)
- Registry access
- Windows file path assumptions (e.g., hardcoded backslashes)

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this if needed.

---

## 5. Run Existing Tests

If the solution contains a test project, run the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the framework migration rather than pre-existing bugs.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify that:

- The connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core, as EF6 does not fully support cross-platform .NET.

---

## 7. Run the Web Application Locally

Start the web application locally and navigate through its core functionality to confirm expected behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- Pages load and render correctly.
- Data reads and writes function as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Configuration and Environment Settings

Confirm that configuration previously handled by `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific overrides (e.g., `appsettings.Development.json`) are in place.

---

## 9. Address Any Remaining Deprecation Warnings

After validating runtime behavior, revisit any compiler warnings logged during the build step. Prioritize:

- Deprecated method or type usage
- Nullable reference type annotations
- Any `[Obsolete]` attributed APIs that may be removed in future framework versions