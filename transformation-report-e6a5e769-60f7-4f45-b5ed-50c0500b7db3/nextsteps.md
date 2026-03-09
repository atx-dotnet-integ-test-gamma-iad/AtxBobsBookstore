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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, even if they do not block the build. Warnings related to nullable reference types or deprecated APIs may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failing tests after a migration often indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database. If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```
- **Configuration**: Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- **Static files and routing**: Navigate through the application in a browser and confirm that pages load correctly and routing behaves as expected.
- **Authentication and authorization**: If the application uses authentication, verify that login, logout, and role-based access work correctly, as these subsystems changed significantly between .NET Framework and cross-platform .NET.

### 5. Check for Platform-Specific API Usage

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to review include:

- `System.Web` references (should no longer be present)
- Windows Registry access (`Microsoft.Win32.Registry`)
- `AppDomain` usage
- Binary serialization (`BinaryFormatter`, which is obsolete and disabled by default)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 6. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files, static assets, and configuration files are present before deploying to your target environment.