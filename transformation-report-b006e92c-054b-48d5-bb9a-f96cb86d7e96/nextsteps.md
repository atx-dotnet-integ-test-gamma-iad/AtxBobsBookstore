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

Inspect each project's `.csproj` for any remaining references to Windows-specific packages or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Any package marked with the `windows` target framework moniker (e.g., `net8.0-windows`)

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC project targeting `System.Web`, verify it has been fully migrated to ASP.NET Core.

### 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new framework version.

### 6. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- If Entity Framework is used, run a check to ensure migrations are up to date:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If a different ORM or raw ADO.NET is used, manually verify that the data access layer connects and queries correctly against the target database.

### 7. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core pages and features load without runtime errors. Check the console output and application logs for any runtime exceptions.

### 8. Review Middleware and Configuration

In `Bookstore.Web`, review `Program.cs` or `Startup.cs` to confirm:

- Middleware is registered in the correct order.
- Services such as authentication, authorization, and dependency injection are configured appropriately for ASP.NET Core.
- Static files, routing, and any custom middleware have been correctly ported.

### 9. Address Any Runtime Warnings

After running the application, review logs for deprecation warnings or runtime notices. These may indicate APIs that function currently but are scheduled for removal in future .NET versions, and should be addressed proactively.