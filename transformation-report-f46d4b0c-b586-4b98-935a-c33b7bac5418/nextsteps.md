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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects and operates correctly:

- Check that the connection string in `appsettings.json` (or equivalent configuration) is valid for your target environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify that it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages or endpoints that interact with the data layer.

### 6. Review Configuration Files

Cross-platform .NET handles configuration differently from .NET Framework in some cases. Verify the following:

- `appsettings.json` contains all settings previously found in `Web.config` or `App.config`.
- Any environment-specific settings are placed in `appsettings.{Environment}.json`.
- Windows-specific configuration sections (such as `system.web` or `system.webServer`) have been removed or replaced with their ASP.NET Core equivalents.

### 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining platform-specific API calls that may cause issues on non-Windows operating systems:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Review and address any `CA1416` platform compatibility warnings that appear in the output.

### 8. Test on Target Platform

If the goal is to run this application on a non-Windows platform (Linux or macOS), perform a full functional test on that platform to surface any remaining compatibility issues that static analysis may not catch.

## Deployment

### 1. Publish the Application

Publish the application to a folder for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm that all required files, including static assets, configuration files, and dependent assemblies, are present.

### 3. Configure the Runtime Environment

Ensure the target server has the correct .NET runtime installed. You can verify the required runtime version from the `<TargetFramework>` element in `Bookstore.Web.csproj`. The appropriate runtime can be downloaded from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

### 4. Set Environment Variables

Set the `ASPNETCORE_ENVIRONMENT` variable on the target server to the appropriate value (for example, `Production`) before starting the application.

```bash
export ASPNETCORE_ENVIRONMENT=Production
```

### 5. Start the Application

Run the published application on the target server:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Confirm the application starts without errors and is accessible on the expected port.