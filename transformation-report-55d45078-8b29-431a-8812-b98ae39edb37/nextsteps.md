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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the current .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The connection string in your configuration file (`appsettings.json`) is correct and accessible from the new runtime environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is the correct version for your target framework.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load without runtime exceptions.
- Data is read from and written to the database correctly.
- Any authentication or authorization mechanisms function as expected.

### 7. Check for Removed or Changed APIs

Review the code for any use of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references (not available in .NET Core and later).
- `ConfigurationManager` usage (replaced by `Microsoft.Extensions.Configuration`).
- Windows-specific APIs that may not function on non-Windows platforms.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility issues.

### 8. Test on Target Platform

If cross-platform support is a goal, run and validate the application on each intended operating system (e.g., Linux, macOS) to surface any platform-specific runtime issues that would not appear during a Windows build.