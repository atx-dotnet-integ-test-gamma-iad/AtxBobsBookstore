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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Run the Application Locally

Start the `Bookstore.Web` project locally to confirm the application runs as expected on the new .NET runtime:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Any database-related functionality (reads and writes) operates as expected through `Bookstore.Data`.
- Domain logic in `Bookstore.Domain` behaves consistently with the original application.

### 5. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core (or other ORM) migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of date, create and apply them:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Check the following areas manually:

- Any use of `System.Web` namespaces, which are not available in modern .NET.
- `HttpContext` usage patterns, which differ between ASP.NET and ASP.NET Core.
- Configuration patterns — `Web.config` is replaced by `appsettings.json` and the `IConfiguration` interface.
- Any Windows-specific APIs such as the registry or certain `System.Drawing` methods.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to identify any remaining compatibility concerns.

### 8. Test on the Target Operating System

If cross-platform support is a goal, run the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during a build.