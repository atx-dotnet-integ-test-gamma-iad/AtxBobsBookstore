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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that your data access layer connects and functions correctly:

- Confirm that your connection strings in `appsettings.json` (or equivalent configuration) are correct for your target environment.
- If the project uses Entity Framework, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that basic CRUD operations work as expected against your database.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and confirm that pages load correctly.
- Test key user flows such as browsing, searching, and any authentication flows if present.
- Check the console and application logs for any runtime exceptions that would not have surfaced during the build step.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Verify the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or environment variables.
- Any configuration transforms that existed for different environments have been replaced with environment-specific `appsettings.{Environment}.json` files.
- Any `<system.web>` or `<system.webServer>` settings have been reviewed and replaced with their ASP.NET Core middleware equivalents where applicable.

### 7. Review Deprecated or Removed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET. Review the following areas:

- Any use of `HttpContext.Current` should be replaced with injected `IHttpContextAccessor`.
- Any use of `System.Web` types should be confirmed as fully removed or replaced.
- Any use of `BinaryFormatter` should be replaced, as it is disabled by default in modern .NET.
- Review any reflection-heavy code, as some behaviors differ between .NET Framework and modern .NET.

### 8. Test on Target Operating System

If the goal of the migration is to run on Linux or macOS, ensure the application is tested on that platform explicitly:

- File path separators, case sensitivity on the file system, and platform-specific APIs can all cause runtime issues that do not appear on Windows.
- Confirm that any file I/O operations use `Path.Combine` and do not rely on hardcoded backslashes.