# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

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

Confirm that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Failures at this stage often indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework is in use, run the following to verify migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output for any runtime exceptions or warnings.
- Verify that any static files, views, or Razor pages render correctly.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- All configuration values previously in `Web.config` have been migrated to `appsettings.json`.
- Environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- Any configuration sections that relied on `System.Configuration.ConfigurationManager` have been updated to use `Microsoft.Extensions.Configuration`.

### 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but may behave differently or be unavailable in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry or Windows identity impersonation.
- Any third-party libraries that may still target .NET Framework only.

Use the following command to check for compatibility issues:

```bash
dotnet-apiport analyze -f Bookstore.Web/bin/Release/
```

> Note: `dotnet-apiport` must be installed separately if not already available.

### 8. Validate Logging and Error Handling

Ensure that logging is correctly configured using `Microsoft.Extensions.Logging`. Verify that errors are surfaced appropriately in both development and production environments by checking the `Program.cs` and any middleware configuration in `Bookstore.Web`.