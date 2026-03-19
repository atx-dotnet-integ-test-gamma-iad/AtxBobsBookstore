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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Review the NuGet packages referenced in each project for any packages that are Windows-only or have known compatibility issues on Linux or macOS. Pay particular attention to:

- Any packages in `Bookstore.Data` related to database access (e.g., SQL Server-specific libraries).
- Any packages in `Bookstore.Web` related to HTTP or session handling that may have platform-specific behavior.

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences in the new runtime.

### 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary workflows, including any data access operations performed by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core or another ORM, confirm that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific variants (`appsettings.Production.json`, etc.) are present and contain the correct values. Settings that were previously stored in `Web.config` or `App.config` should now be represented in the JSON-based configuration system.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce the deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Deploy to Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed. The required runtime version can be confirmed by checking the `<TargetFramework>` value in the web project's `.csproj` file.

### 4. Confirm Runtime Behavior in the Target Environment

After deployment, perform a basic smoke test by accessing the application and verifying that core functionality, including data retrieval and any write operations, works as expected in the production environment.