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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to ensure you are targeting a version that is still within its support window.

### 5. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are up to date. Run pending migrations if necessary:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Configuration**: Verify that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- **Static files and routing**: Navigate through the application to confirm pages load correctly and routing behaves as expected.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that login and access control work as intended.

### 6. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that behave differently or have been removed in modern .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced during transformation.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages, which now come from `Microsoft.AspNetCore.Http`.
- Any Windows-specific APIs (e.g., registry access, Windows identity) that may not function on non-Windows platforms.

### 7. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and dependencies are present before deploying to your target environment.