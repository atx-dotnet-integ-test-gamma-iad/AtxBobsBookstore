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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated as part of the migration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-fatal, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if applicable) are functioning correctly.
- **File paths**: Ensure any file I/O operations use `Path.Combine` or equivalent cross-platform path handling rather than hardcoded backslashes.
- **Configuration**: Verify that `appsettings.json` or environment-based configuration is loading correctly, replacing any legacy `Web.config` or `App.config` values that may have been migrated.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware, confirm that it initializes and functions correctly.
- **Static assets**: Confirm that CSS, JavaScript, and image assets are being served properly.

### 5. Review Replaced APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Review the codebase in `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` for any usage of the following, which may compile but fail at runtime:

- `System.Web` namespaces
- Windows Registry access
- `HttpContext.Current` (replaced by `IHttpContextAccessor`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same major version to avoid inter-project compatibility issues.

### 7. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target hosting environment, ensuring the correct .NET runtime version is installed on the host.