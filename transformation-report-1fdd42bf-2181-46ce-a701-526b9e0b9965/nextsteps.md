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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-specific framework moniker unless intentionally required.

### 4. Check for Windows-Specific Dependencies

Inspect each project for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- COM interop

These will not function correctly on non-Windows platforms and should be replaced with cross-platform alternatives.

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by the migration or were pre-existing.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following areas at a minimum:

- Application startup without exceptions
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- All primary user-facing routes and pages load correctly

### 7. Verify Database Migrations

If Entity Framework Core is in use within `Bookstore.Data`, confirm that migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of date, generate a new migration and apply it to the target database:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and contain valid settings, particularly:

- Connection strings
- Logging configuration
- Any application-specific keys previously stored in `Web.config`

Note that `Web.config` is not used in cross-platform .NET applications. Any relevant settings must be migrated to `appsettings.json`.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce a deployment-ready output:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files are present, including static assets, configuration files, and compiled assemblies.

### 3. Test the Published Output

Run the published application directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Perform the same manual verification steps outlined in section 6 against this published output before deploying to any environment.