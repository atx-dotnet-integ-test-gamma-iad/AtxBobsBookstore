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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older or out-of-support version is present (e.g., `net6.0`), consider updating to the latest Long Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `Microsoft.Win32` registry access
- Windows-only NuGet packages
- Platform-specific file path assumptions (e.g., backslashes)

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to help identify these.

---

## 5. Verify Entity Framework Core Configuration

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Migrations are present and up to date.

Run the following to check migration status:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply any pending migrations to your database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output and manually verify core functionality such as browsing, searching, and any data-driven pages.

---

## 7. Execute Automated Tests

If a test project exists in the solution, run all tests to confirm existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration.

---

## 8. Validate Cross-Platform Behavior

If cross-platform support is a requirement, run and test the application on each target operating system (Windows, Linux, macOS) to confirm consistent behavior. Pay particular attention to:

- File I/O operations
- Connection strings and configuration loading via `appsettings.json`
- Authentication and session handling

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.