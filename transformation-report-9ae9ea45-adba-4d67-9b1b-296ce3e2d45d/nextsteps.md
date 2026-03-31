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

Check the output for any warnings that, while non-blocking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results and address any failures before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Core domain logic in `Bookstore.Domain` functions correctly end-to-end through the UI.
- Any pages or API endpoints that interact with data return expected results.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Windows-Specific Dependencies

Even when a build succeeds, some NuGet packages or APIs may only function on Windows. Review the dependencies in each project for any packages that have a `windows` target framework moniker or rely on Windows-specific APIs such as the registry, WCF, or the `Microsoft.Win32` namespace.

### 7. Review Entity Framework or Data Access Configuration

In `Bookstore.Data`, verify that the database provider is configured correctly for cross-platform use. For example, if SQL Server is being used, confirm the connection string and provider registration are in place in the application's startup configuration.

### 8. Inspect Application Configuration

Review `appsettings.json` and any environment-specific configuration files in `Bookstore.Web` to ensure connection strings, service URLs, and other settings are accurate for the target deployment environment.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all required files are present, including static assets, configuration files, and dependent assemblies.

### 3. Run the Published Output

Test the published output directly before deploying to a server:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Confirm the application runs correctly from the published artifacts.

### 4. Deploy to Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the correct version of the .NET runtime is installed on the target machine. The required runtime version can be confirmed by checking the `<TargetFramework>` value in the web project file.