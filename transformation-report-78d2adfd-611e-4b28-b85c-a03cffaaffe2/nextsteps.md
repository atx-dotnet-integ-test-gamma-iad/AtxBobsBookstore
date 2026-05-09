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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless explicitly required.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining dependencies that are Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- COM interop components
- `Microsoft.Web.*` packages that do not support cross-platform .NET

These will not always produce build errors but may cause runtime failures on non-Windows platforms.

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences in the new framework version.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- Database connectivity through `Bookstore.Data`
- Domain logic execution through `Bookstore.Domain`
- All primary web routes and pages load without errors
- Any authentication or authorization flows behave correctly

### 7. Validate Database Migrations

If the project uses Entity Framework Core, confirm that migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations were originally written for EF6, they will need to be recreated for EF Core.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously stored in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` transformation system is not used in cross-platform .NET, so any environment-specific configuration should be handled via `appsettings.{Environment}.json` or environment variables.

### 9. Deploy to Target Environment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and confirm the application starts correctly in that environment.