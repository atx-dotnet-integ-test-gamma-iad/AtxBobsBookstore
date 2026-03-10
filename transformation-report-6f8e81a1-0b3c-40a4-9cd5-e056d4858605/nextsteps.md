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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key domain operations through the UI or API endpoints to confirm correct behavior.
- **Configuration**: Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or environment variables.
- **Static assets and routing**: Navigate through the web application to confirm that pages render correctly and routes resolve as expected.

### 5. Review Replaced or Removed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues that would not surface as build errors:

- **`System.Web` dependencies**: Any code that previously relied on `System.Web` types may need to be replaced with ASP.NET Core equivalents.
- **Windows-specific APIs**: Features such as the Windows Registry, WCF server-side hosting, or Windows Authentication may require alternative implementations.
- **Third-party libraries**: Confirm that all NuGet packages referenced in the projects have versions compatible with the target .NET version.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including configuration files and static assets, are present before deploying to the target environment.