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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- The connection string format is compatible with the target database provider.
- Any Entity Framework Core migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application to verify it runs correctly on the new framework:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test core functionality, including any pages or endpoints that interact with `Bookstore.Domain` and `Bookstore.Data`.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `Web.config`.
- Environment-specific settings (e.g., connection strings, API keys) are correctly configured for each target environment.
- Any configuration transforms that existed in the legacy project have been manually replicated.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not behave correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes).
- Registry access, which is not available on non-Windows platforms.
- Windows-specific authentication mechanisms such as Windows Authentication or NTLM.

### 8. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid cross-framework compatibility issues.

### 9. Publish the Application

Once validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present.