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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during restoration, particularly around package compatibility with the target framework.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If test projects exist within the solution, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the framework change.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects and operates correctly:

- Check that connection strings in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If the project migrated from Entity Framework 6 to Entity Framework Core, manually test all key queries and data operations, as there are known behavioral differences between the two versions.

### 5. Run the Web Application Locally

Start the web application and perform manual verification of core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application and test all primary user-facing features.
- Check browser developer tools and application logs for any runtime errors.
- Verify that static assets (CSS, JavaScript, images) are served correctly.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains all settings previously held in `Web.config` or `App.config`.
- Verify that environment-specific configuration (e.g., `appsettings.Development.json`) is in place.
- Ensure that any custom HTTP handlers, modules, or `system.web` settings from the legacy project have been accounted for in the middleware pipeline (`Program.cs` or `Startup.cs`).

### 7. Check Logging and Error Handling

- Confirm that logging is configured correctly, using `Microsoft.Extensions.Logging` or a compatible provider.
- Trigger known error conditions to verify that error handling and logging behave as expected.

### 8. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file for the `<TargetFramework>` element:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects in the solution.

## Deployment

Once all validation steps pass:

1. Publish the web application using:

```bash
dotnet publish --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory to confirm all required files are present.
3. Deploy the published output to the target server or hosting environment, ensuring the correct .NET runtime version is installed on the host.