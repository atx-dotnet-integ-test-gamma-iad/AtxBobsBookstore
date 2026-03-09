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

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` file for any remaining references to Windows-specific packages or APIs, such as:

- `Microsoft.Web.Infrastructure`
- `System.Web`
- `System.Drawing` (without the `System.Drawing.Common` cross-platform package)
- Any package with a `net48` or `net45` target only

If any are found, replace them with their cross-platform equivalents or remove them if they are no longer needed.

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by behavioral differences in the new runtime.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically validate the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the primary business workflows to confirm `Bookstore.Domain` behaves correctly.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm expected responses.

### 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain the correct configuration values. Legacy `Web.config` or `App.config` settings that were previously used should now be represented in the appropriate `appsettings.json` file.

### 8. Validate Deployment Output

Publish the application to a local folder to confirm the published output is complete and self-contained:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assemblies, static assets, and configuration files are present before deploying to the target environment.