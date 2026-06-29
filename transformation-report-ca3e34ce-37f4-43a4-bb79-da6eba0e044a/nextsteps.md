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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

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

Inspect each project's `.csproj` for any remaining references to Windows-specific packages or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry APIs
- `System.Drawing` (without the `System.Drawing.Common` NuGet package)

If any are found, replace them with their cross-platform equivalents.

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they indicate a behavioral regression introduced during migration.

### 6. Run the Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically validate:

- Database connectivity through `Bookstore.Data`
- Domain logic behavior in `Bookstore.Domain`
- All major web routes and pages load without errors
- Any authentication or authorization flows work as expected

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that existing migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If migrations were generated under a previous EF version, consider verifying the generated SQL against your target database.

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and correctly structured. Settings that were previously in `Web.config` should now reside in these JSON configuration files.

### 9. Check Middleware and Startup Configuration

If the project was migrated from ASP.NET MVC (Framework) to ASP.NET Core, review `Program.cs` and any `Startup.cs` to ensure:

- Middleware is registered in the correct order
- Services such as routing, authentication, and static files are properly configured
- Any HTTP handlers or modules from the legacy project have been replaced with equivalent ASP.NET Core middleware