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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If the project uses Entity Framework, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the core domain features through the UI or API endpoints to confirm `Bookstore.Domain` behaves correctly.
- **Configuration**: Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Static assets**: Verify that CSS, JavaScript, and image assets are served correctly.
- **Authentication and Authorization**: If the application uses any authentication middleware, confirm that login and access control function as expected.

### 5. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues that would not appear as build errors:

- **`System.Web` dependencies**: Ensure no runtime code paths rely on `System.Web` types, as this namespace is not available in cross-platform .NET.
- **Windows-specific APIs**: If any libraries or calls depend on Windows Registry, Windows Identity, or COM interop, these may fail on non-Windows environments or may require replacement packages.
- **Third-party libraries**: Confirm that all NuGet packages in use have versions that are compatible with the target .NET version (e.g., .NET 6, 7, or 8).

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses the web-specific target if applicable:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.