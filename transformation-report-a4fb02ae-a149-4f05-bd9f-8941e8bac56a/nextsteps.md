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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that may indicate compatibility issues even if the build succeeds, such as obsolete API usage or platform-specific warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new runtime or framework version.

### 4. Verify Data Layer

Since `Bookstore.Data` likely interacts with a database, verify the following:

- Confirm that the database provider package (e.g., Entity Framework Core, Dapper) is compatible with the target .NET version.
- If using Entity Framework Core, check that any existing migrations are still valid by running:

```bash
dotnet ef migrations list
```

- Test the database connection against your target database to ensure connectivity and schema compatibility.

### 5. Review Configuration Files

- Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, application settings, and environment-specific values have been correctly migrated.
- Ensure that any configuration transformations previously handled by `Web.config` transforms are now handled through environment-specific `appsettings.{Environment}.json` files or environment variables.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

- Navigate through the application and test primary user-facing features.
- Check browser developer tools and application logs for any runtime errors that would not surface at build time.
- Verify that static assets, routing, and middleware are functioning as expected.

### 7. Review Removed Windows-Specific Dependencies

Cross-platform migration may have removed or replaced APIs that were Windows-specific. Review the following areas:

- Any use of `System.Web` APIs, which are not available in .NET Core or later.
- Windows-specific authentication mechanisms such as Windows Authentication or NTLM, which may require additional configuration on non-Windows hosts.
- File path handling to ensure `Path.Combine` is used consistently rather than hardcoded backslashes.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, assemblies, and static assets are present before deploying to the target environment.