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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Runtime Behavior

Start the web application locally and manually exercise the core workflows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which commonly surface runtime issues after migration:

- **Database connectivity**: Verify that `Bookstore.Data` connects and queries correctly. Check your connection strings in `appsettings.json`, as the format or provider may have changed.
- **Entity Framework**: If Entity Framework is used, confirm that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Authentication and Authorization**: If the application uses ASP.NET Identity or custom auth middleware, test login and access control flows explicitly.
- **Static files and routing**: Confirm that pages, views, and API routes resolve correctly in the browser.

### 5. Check for Removed or Changed APIs

Review the code for any use of APIs that existed in .NET Framework but behave differently or have been removed in cross-platform .NET. Common areas include:

- `System.Web` references (these are not available in cross-platform .NET and should have been replaced during transformation)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext.Current` (replaced by injected `IHttpContextAccessor`)
- Windows-specific APIs such as the registry or certain cryptography providers

### 6. Validate Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Ensure environment-specific settings are correctly structured using `appsettings.Development.json` or environment variables as appropriate.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assets, and dependencies are present before deploying to your target environment.