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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete API usage, as these can indicate subtle compatibility issues introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior are preserved after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Validate the Data Layer

Since `Bookstore.Data` likely contains Entity Framework or another data access mechanism, verify the following:

- **Database provider packages** are compatible with the target .NET version (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or the appropriate provider).
- **Migrations** are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Manually test key user-facing features such as browsing, searching, and any data submission flows.
- Check the console and application logs for runtime exceptions or deprecation warnings.

---

## 7. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm:

- Connection strings are correct and point to the intended database.
- Any configuration keys previously stored in `Web.config` (from the legacy project) have been properly migrated to the `appsettings.json` format.
- Environment-specific settings are separated appropriately.

---

## 8. Check for Windows-Specific Dependencies

Since the goal is cross-platform compatibility, audit the codebase for any remaining Windows-specific APIs or libraries, such as:

- `Microsoft.Win32` namespace usage
- Windows registry access
- COM interop
- `System.Web` references (which are not available in cross-platform .NET)

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface platform-specific warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

If a self-contained deployment is preferred (no runtime dependency on the host), use:

```bash
dotnet publish Bookstore.Web --configuration Release --self-contained true --runtime linux-x64 --output ./publish
```

Replace `linux-x64` with the appropriate runtime identifier for your target platform (e.g., `win-x64`, `osx-x64`).