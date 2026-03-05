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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings, even if there are no errors. Warnings related to nullable reference types, deprecated APIs, or target framework compatibility should be reviewed and addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay particular attention to the following areas, as they are common sources of runtime differences after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are up to date by running `dotnet ef database update`.
- **Configuration**: Ensure that `appsettings.json` contains all necessary values that were previously in `Web.config` or `App.config`. Connection strings and application settings should be confirmed.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or Windows Authentication, verify that the relevant middleware is correctly configured in `Program.cs` or `Startup.cs`.
- **Static files and routing**: Confirm that pages, views, and API endpoints resolve correctly in the browser.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the web project uses ASP.NET Core, confirm it targets a currently supported .NET version.

### 6. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that behave differently on cross-platform .NET compared to .NET Framework. Common areas to check include:

- `System.Web` references, which are not available in .NET Core or later.
- `BinaryFormatter`, which is disabled by default in modern .NET.
- Registry access or Windows-specific APIs, which will not function on non-Windows platforms.
- `ConfigurationManager`, which requires the `System.Configuration.ConfigurationManager` NuGet package if still in use.

### 7. Test on Target Platform

If the intent is to run this application on Linux or macOS, perform a test run on that operating system to surface any remaining platform-specific issues that would not appear on Windows.