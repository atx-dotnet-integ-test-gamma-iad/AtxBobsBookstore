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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup and routing
- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- Any pages or API endpoints that interact with data access or business logic

### 5. Review Data Layer Compatibility

Since `Bookstore.Data` handles data access, verify the following:

- The database provider NuGet package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) targets the correct version compatible with your new .NET target framework.
- Any existing database migrations are still valid by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If migrations are out of sync, apply them to a test database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Check for Removed or Changed APIs

Review the code for any use of APIs that were available in .NET Framework but have changed behavior or limited support in cross-platform .NET. Common areas to check include:

- `System.Web` references (these are not available in cross-platform .NET)
- Windows-specific APIs such as the registry or certain cryptography providers
- Any third-party libraries that may still target .NET Framework only

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to identify any remaining compatibility concerns:

```bash
upgrade-assistant analyze app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Configuration Files

Confirm that configuration has been correctly migrated from `Web.config` or `App.config` to `appsettings.json`. Verify that:

- Connection strings are present and correct in `appsettings.json`
- Environment-specific settings are handled using `appsettings.{Environment}.json`
- Any configuration values previously read via `ConfigurationManager` are now accessed through `IConfiguration`

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to your target environment.