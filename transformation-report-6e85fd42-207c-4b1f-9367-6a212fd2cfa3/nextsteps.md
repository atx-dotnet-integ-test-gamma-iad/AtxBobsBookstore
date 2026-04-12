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

Review any failing tests to determine whether they are caused by behavioral differences between the legacy .NET Framework and the current .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection string in your configuration file (`appsettings.json`) is valid and points to the correct database.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you are using a database provider that was previously Windows-specific (e.g., certain SQL Server drivers), confirm the NuGet package used is the cross-platform compatible version such as `Microsoft.EntityFrameworkCore.SqlServer`.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core application functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows such as browsing, searching, and any authentication flows.

### 7. Check for Windows-Specific APIs

Even without build errors, runtime issues can arise from APIs that existed in .NET Framework but behave differently or are absent in cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to any `CA1416` warnings, which indicate platform-specific API usage.

### 8. Review Configuration and Middleware (Bookstore.Web)

Confirm that the `Bookstore.Web` project has been updated from the legacy `System.Web`-based pipeline to the ASP.NET Core middleware pipeline. Verify the following:

- `Program.cs` or `Startup.cs` follows the ASP.NET Core pattern.
- Authentication, authorization, session, and routing middleware are explicitly registered.
- Any `Web.config` settings have been migrated to `appsettings.json` or environment variables.

### 9. Test on the Target Operating System

If the goal is cross-platform support, run the application on the target non-Windows operating system (e.g., Linux or macOS) to surface any remaining platform-specific issues that would not appear during Windows development.