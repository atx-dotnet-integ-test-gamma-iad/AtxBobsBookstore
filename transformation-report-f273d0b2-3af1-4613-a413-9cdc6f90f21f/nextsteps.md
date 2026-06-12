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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new framework version or by incomplete migration of specific features.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are compatible with the current version of EF Core being used:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

If migrations were originally written for EF 6 or an older version of EF Core, you may need to recreate them:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

Ensure the connection string in your configuration file (`appsettings.json`) is correctly set up for your target database environment.

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that all configuration values have been moved to `appsettings.json` or environment variables, including:

- Database connection strings
- Application settings previously stored in `<appSettings>`
- Any custom configuration sections

---

## 6. Validate Middleware and Startup Configuration (Bookstore.Web)

If the web project was migrated from ASP.NET (System.Web) to ASP.NET Core, review the `Program.cs` and any middleware configuration to ensure the following are correctly set up:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Session and cookie handling

Run the application locally and navigate through the key workflows to verify expected behavior:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS. Common areas to check include:

- `System.Web` references
- Windows Registry access
- Windows-specific file path assumptions (backslashes vs. forward slashes)
- COM interop or P/Invoke calls

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package can help identify these.

---

## 8. Test on Target Platform

If cross-platform support is a goal, run the application on the intended target operating system (Linux or macOS) to surface any remaining platform-specific issues that may not appear on Windows.

---

## 9. Review Target Framework Version

Open each `.csproj` file and confirm the `<TargetFramework>` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a Long-Term Support (LTS) version is preferred, ensure all three projects are aligned to the same framework version to avoid compatibility issues between projects.