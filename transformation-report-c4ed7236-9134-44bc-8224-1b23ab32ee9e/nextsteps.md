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

Check the output for any warnings, even if there are no errors. Warnings related to nullable reference types or obsolete APIs may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. If tests were previously written against .NET Framework-specific behavior, some may require updates to align with cross-platform .NET behavior.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations apply cleanly with `dotnet ef database update`.
- **Configuration**: Ensure that any settings previously in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment variables.
- **Static files and routing**: Confirm that pages, assets, and API routes resolve correctly in the browser.
- **Authentication and authorization**: If the application uses ASP.NET Identity or Windows Authentication, verify that login and access control work as expected on the target platform.

### 5. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to inspect include:

- `System.Web` references (these are not available in cross-platform .NET)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side code
- `AppDomain` usage beyond what is supported in .NET 5+

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the project targets a version that is out of support, consider updating to the current Long-Term Support (LTS) release.

### 7. Publish the Application

Once validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.