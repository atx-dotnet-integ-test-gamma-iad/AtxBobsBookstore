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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any NuGet packages or references that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web` (not available in cross-platform .NET)
- Any package with a `windows` target framework condition

If any are found, identify cross-platform alternatives or conditionally target them using `<TargetFramework>net8.0-windows</TargetFramework>` if Windows-only deployment is acceptable.

### 5. Run Unit Tests

If the solution contains test projects, execute them to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between .NET Framework and the new .NET version.

### 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually test the primary user flows, such as browsing, searching, and any data entry features.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all required configuration values that were previously in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

### 9. Validate Middleware and HTTP Pipeline

If `Bookstore.Web` is an ASP.NET Core application, review `Program.cs` or `Startup.cs` to confirm that all required middleware is registered, including authentication, authorization, static files, and routing.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Test on the Target Environment

Deploy the contents of the `./publish` directory to the target server or hosting environment and verify the application starts and operates correctly in that context. Confirm the runtime environment has the appropriate .NET version installed:

```bash
dotnet --version
```