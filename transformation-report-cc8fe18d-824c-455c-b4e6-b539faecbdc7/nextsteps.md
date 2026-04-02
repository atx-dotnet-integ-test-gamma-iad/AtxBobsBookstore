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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, especially those related to deprecated APIs or nullable reference types, as these can indicate areas where the code may behave differently on cross-platform .NET compared to .NET Framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated before proceeding, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that the connection strings in your configuration files (`appsettings.json`) are correct and that Entity Framework Core (if used) migrations are up to date. Run `dotnet ef database update` if needed.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or cookie-based auth, verify that login and access control work as expected.
- **Static files and routing**: Confirm that pages, views, and API routes resolve correctly.
- **Configuration loading**: Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or environment variables.

### 5. Check for Platform-Specific Code

Review the codebase for any remaining usage of Windows-specific APIs or libraries that may not function correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- `System.Drawing` (replace with a library such as `SkiaSharp` or `ImageSharp` if needed)
- Windows Registry access
- COM interop
- `System.Web` references that may have been carried over

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-targeting issues.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files, including static assets and configuration files, are present before deploying to the target environment.