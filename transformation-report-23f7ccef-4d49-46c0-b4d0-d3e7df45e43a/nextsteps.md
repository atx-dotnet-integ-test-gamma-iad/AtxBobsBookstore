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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Review any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify that:
- Pages load without errors
- Database reads and writes function correctly
- Any authentication or session handling works as expected

### 5. Check for Platform-Specific API Usage

Even without build errors, some APIs that were available in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Review the following areas manually:

- **`Bookstore.Data`**: Confirm that the Entity Framework provider (e.g., EF Core) is correctly configured and that any database migrations are up to date. Run `dotnet ef migrations list` to check migration state.
- **`Bookstore.Web`**: Verify that any HTTP handlers, modules, or `System.Web` dependencies have been properly replaced with their ASP.NET Core equivalents (middleware, filters, etc.).
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `ConfigurationManager`, or other .NET Framework-specific types that may have been substituted during transformation.

### 6. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all necessary configuration values that were previously held in `web.config` or `app.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Logging configuration

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, views, and configuration files are present before deploying to your target environment.