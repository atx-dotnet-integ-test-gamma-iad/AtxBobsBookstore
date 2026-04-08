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

Verify that no warnings or errors appear during restoration. If any packages fail to restore, check that the package versions specified in each `.csproj` file are compatible with the target .NET version.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, particularly deprecation warnings, that may indicate APIs that need to be updated even if they do not currently cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute all tests to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, test the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database and performs reads and writes correctly. Pay attention to any Entity Framework Core migration differences if the project was previously using EF6.
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering behave as expected.

### 5. Check Configuration Files

Review `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) to ensure that:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 6. Review Middleware and Startup Configuration

In `Bookstore.Web`, inspect the `Program.cs` or `Startup.cs` file to confirm that:

- Middleware is registered in the correct order.
- Authentication, authorization, and session configuration (if applicable) are present and correct.
- Static file serving is configured if the application serves client-side assets.

### 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required assemblies, static files, and configuration files are present before deploying to the target environment.