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

Run a full solution build to confirm the absence of any build errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for any usage of APIs that are not available in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available outside of ASP.NET on .NET Framework
- Windows-specific registry or file path assumptions
- Any P/Invoke calls targeting Windows-only libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining compatibility issues.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and verify that it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the primary workflows of the application, including any database interactions handled by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core or another data access library, verify the following:

- The connection string in `appsettings.json` is correct for the target environment
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific variants such as `appsettings.Production.json` contain all required configuration values that may have previously been stored in `Web.config` or `App.config` files.

### 9. Check Logging and Middleware

If the project previously used `System.Web` HTTP modules or handlers, verify that equivalent ASP.NET Core middleware has been configured in `Program.cs` or `Startup.cs`.

### 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets and dependencies are present before deploying to the target environment.