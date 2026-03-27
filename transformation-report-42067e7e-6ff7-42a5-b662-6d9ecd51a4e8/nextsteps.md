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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48` or `netcoreapp3.x`, update it to a current long-term support (LTS) release.

---

## 4. Check for Windows-Specific APIs

Search the codebase for APIs that are Windows-only and may not function correctly on Linux or macOS. Common examples include:

- `System.Windows.Forms`
- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` for file path handling to ensure cross-platform compatibility.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that the database provider and migrations are compatible with the new target framework.

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If migrations are out of date or missing, generate a new migration and apply it to the target database.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate that existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality such as page rendering, data retrieval, and form submissions.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions, middleware configuration errors, or missing configuration values (e.g., connection strings in `appsettings.json`).

---

## 8. Validate Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. The `System.Configuration.ConfigurationManager` approach from .NET Framework is replaced by `Microsoft.Extensions.Configuration` in cross-platform .NET.

---

## 9. Review Startup and Middleware Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm that all middleware, services, and dependency injection registrations are correct. Pay particular attention to:

- Authentication and authorization middleware
- Static file serving
- Database context registration
- Any custom HTTP modules or handlers that were migrated from the legacy project