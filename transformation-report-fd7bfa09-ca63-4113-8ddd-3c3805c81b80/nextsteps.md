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

Check the output for any warnings that may indicate compatibility issues, even if they do not prevent compilation.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only. Common areas to check include:

- Any usage of `Microsoft.Win32` namespaces
- References to `System.Web` (not supported on cross-platform .NET)
- Any P/Invoke calls targeting Windows-specific native libraries
- Packages that have not been updated for cross-platform .NET

### 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, including any data access operations performed by `Bookstore.Data`.

### 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing behavior has been preserved:

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a regression introduced during the migration or a pre-existing issue.

### 7. Validate Database Connectivity

Since `Bookstore.Data` handles data access, confirm that:

- The connection string in your configuration file (`appsettings.json` or equivalent) is correct for your target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If migrations need to be applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no hidden platform-specific dependencies that only surface at runtime.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Review runtime logs carefully for any `PlatformNotSupportedException` or similar errors.

### 9. Review Startup and Middleware Configuration

If the project was migrated from ASP.NET (Framework) to ASP.NET Core, review `Program.cs` and any middleware configuration to ensure:

- Authentication and authorization middleware is correctly configured.
- Static file serving is set up properly.
- Any custom HTTP modules or handlers from the legacy project have been replaced with the appropriate ASP.NET Core middleware equivalents.