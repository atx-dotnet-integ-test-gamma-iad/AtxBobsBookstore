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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration.

### 5. Verify Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Any Entity Framework or database provider packages have been updated to their cross-platform compatible versions (e.g., `Microsoft.EntityFrameworkCore`).
- Database migrations are intact and can be applied. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to a local database for testing:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end behavior is intact.

### 7. Check for Windows-Specific APIs

Even without build errors, runtime issues can arise from APIs that were available on .NET Framework but behave differently or are unavailable on cross-platform .NET. Review the codebase for usage of:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `ConfigurationManager` (replace with `Microsoft.Extensions.Configuration` if not already done)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to perform a more thorough API compatibility scan if needed.

### 8. Review Application Configuration

Confirm that `appsettings.json` (or equivalent) contains all configuration values that were previously in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Any environment-specific overrides via `appsettings.Development.json`

### 9. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to the target environment according to your hosting setup (IIS, Linux host, etc.). Ensure the target server has the appropriate .NET runtime installed.