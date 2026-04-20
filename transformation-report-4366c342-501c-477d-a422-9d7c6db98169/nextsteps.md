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

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, runtime failures can occur if the code uses Windows-specific APIs. Run the .NET compatibility analyzer if it is not already enabled by adding the following to each `.csproj`:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

Rebuild and review any new analyzer warnings related to platform compatibility, particularly in `Bookstore.Data` where database or file system access may be present.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new runtime or by environment-specific configuration.

### 6. Verify Database Connectivity

For `Bookstore.Data`, confirm that the data access layer functions correctly in the new environment:

- Verify connection strings in `appsettings.json` or equivalent configuration files are valid for the target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 7. Run the Application Locally

Start the web application and perform manual verification of core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify that key features such as browsing, data retrieval, and any forms or submissions behave as expected.

### 8. Review Configuration and Middleware

In `Bookstore.Web`, review `Program.cs` or `Startup.cs` to confirm that middleware registration and configuration loading are compatible with the current .NET version. Pay particular attention to:

- Authentication and authorization middleware
- Static file serving
- Any legacy `HttpModule` or `HttpHandler` equivalents that may have been migrated to middleware

### 9. Deploy to Target Environment

Once local validation is complete:

1. Publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

2. Copy the contents of the `./publish` directory to the target server or hosting environment.
3. Confirm the target machine has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

4. Start the application and perform the same validation steps outlined above in the production or staging environment.