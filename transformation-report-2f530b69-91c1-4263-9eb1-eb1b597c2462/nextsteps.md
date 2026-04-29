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

Review the output for any warnings related to deprecated packages or version conflicts and resolve them if present.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

At a minimum, confirm the following:

- The application starts without runtime exceptions.
- Database connectivity is functional (check connection strings in `appsettings.json` for any platform-specific paths or legacy configurations that may need updating).
- Core application routes and pages load as expected.
- Any data access operations (reads and writes) function correctly against the target database.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) for the following:

- Connection strings that may reference Windows-specific paths or legacy SQL Server configurations.
- Any references to legacy `System.Configuration` or `ConfigurationManager` patterns that should be replaced with the `Microsoft.Extensions.Configuration` approach standard in modern .NET.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid interoperability issues.

### 7. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or the appropriate provider for your database).
- Any migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once the above steps are validated, publish the application to confirm a clean release output:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify that all expected assets, configuration files, and binaries are present before deploying to the target environment.