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

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results to ensure all previously passing tests continue to pass. Pay particular attention to any tests that exercise data access logic in `Bookstore.Data` or domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup completes without exceptions.
- Database connections are established correctly. If the project previously used SQL Server with Windows Authentication, confirm that the connection string has been updated to use a compatible authentication method for the target platform.
- All primary application routes and pages load correctly.
- Any file system paths used in the application (e.g., for uploads or configuration files) use `Path.Combine` rather than hardcoded backslash-separated strings, as backslashes are not valid path separators on Linux and macOS.

### 5. Review Configuration Files

Open `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) and confirm the following:

- Connection strings reference a database server accessible from the target platform.
- Any paths or environment-specific values are appropriate for the new runtime environment.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element references a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or other Windows-only target monikers.

### 7. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.