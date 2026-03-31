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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need further attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. If tests were written against the legacy .NET Framework behavior, some may require updates to align with cross-platform .NET behavior.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that the data layer functions correctly:

- Confirm that the connection strings in `appsettings.json` (or equivalent configuration files) are correct for your target environment.
- If Entity Framework is used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database schema is created or updated as expected.

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that static assets, routing, and authentication (if applicable) behave correctly.

### 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All necessary configuration values (connection strings, API keys, application settings) have been migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Any environment-specific settings are correctly separated by environment.
- No sensitive values are hardcoded or left in legacy configuration files.

### 7. Check for Platform-Specific Code

Even without build errors, some code may have platform-specific behavior that only surfaces at runtime on non-Windows systems. Review the codebase for:

- Use of `System.Drawing` (not fully supported cross-platform without additional packages).
- Windows registry access.
- Hardcoded Windows file path separators (`\` instead of `Path.Combine`).
- Any P/Invoke calls targeting Windows-only native libraries.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy framework, update it accordingly and re-run the build and tests.