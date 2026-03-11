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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that the output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected (verify connection strings in `appsettings.json` are correct for your environment).
- Core application flows such as browsing, searching, and any data entry functions work correctly.

### 5. Review Configuration Files

Confirm that any configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Database connection strings
- Any application-specific settings
- Authentication or authorization configuration

### 6. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that exist in .NET but behave differently across platforms, or from libraries that were not fully cross-platform. Review the following:

- Any use of the Windows registry
- File path separators (use `Path.Combine` rather than hardcoded separators)
- Any P/Invoke calls or Windows-specific libraries referenced in `Bookstore.Data` or `Bookstore.Domain`

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` element reflects the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or another .NET Framework moniker unless intentionally targeting multiple frameworks.

### 8. Database Migrations

If the project uses Entity Framework, verify that any existing migrations are compatible with the updated version of EF Core. Run the following to apply migrations against your development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm the schema is applied correctly and that the application can read and write data without errors.

## Deployment

Once all of the above validation steps pass without errors:

1. Publish the application using the following command, targeting your intended runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Copy the contents of the `./publish` directory to your target server or hosting environment.

3. Ensure the target environment has the appropriate .NET runtime installed. You can verify the required version from the `.csproj` file and download the corresponding runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

4. Configure your web server (IIS, Nginx, or Apache) to serve the application, following the official Microsoft guidance for hosting ASP.NET Core applications on your chosen platform.