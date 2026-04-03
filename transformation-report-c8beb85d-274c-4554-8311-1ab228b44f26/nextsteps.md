# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 2. Restore Dependencies

Run a full NuGet restore from the solution root to ensure all packages are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated packages or version conflicts and resolve them before proceeding.

---

## 3. Build the Solution

Perform a clean build to confirm there are no hidden warnings or errors:

```bash
dotnet build --configuration Release
```

Address any warnings that could indicate runtime issues, such as nullable reference warnings or obsolete API usage.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review any failing tests. Failures may indicate behavioral differences introduced by the framework migration, such as changes in serialization, dependency injection, or middleware behavior.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) is referencing the correct cross-platform compatible package version.
- Run any pending migrations or verify the database schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Test basic CRUD operations against a local or development database to confirm data access is functioning correctly.

---

## 6. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain logic that may have relied on Windows-specific APIs (e.g., `System.Drawing`, registry access, or Windows file path assumptions).
- Confirm that all business logic produces expected results by running integration or unit tests targeting this layer specifically.

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally and navigate through the primary user flows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Check the following areas specifically:
  - Authentication and authorization middleware
  - Static file serving
  - Configuration loading (confirm `appsettings.json` is being read correctly and that any `web.config` transforms have been replaced with the appropriate .NET configuration equivalents)
  - Routing behavior

---

## 8. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all settings that were previously in `web.config` or `app.config`.
- Confirm that connection strings, logging settings, and any environment-specific values are correctly defined.

---

## 9. Cross-Platform Smoke Test

If the goal is to run on a non-Windows OS, perform a smoke test on the target platform (Linux or macOS):

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then run the published output on the target machine and verify the application starts and responds correctly.

---

## 10. Review Deprecated or Removed APIs

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any APIs used in the codebase that have been removed or altered in the target framework version. Address any findings before considering the migration complete.