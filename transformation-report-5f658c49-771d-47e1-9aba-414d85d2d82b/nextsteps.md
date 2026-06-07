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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compilation errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for any use of APIs that were available in .NET Framework but have been removed or altered in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET and should be replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.

### 6. Review Database Connectivity in `Bookstore.Data`

If Entity Framework is used, confirm the version being referenced is compatible with modern .NET:

- Entity Framework Core should be used in place of Entity Framework 6 where applicable.
- Verify that the connection string configuration has been updated to use `appsettings.json` rather than `web.config` or `app.config`.

### 7. Run the Application Locally

Start the application using the .NET CLI:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality, such as browsing, searching, and any data operations, behaves as expected.

### 8. Review `appsettings.json` Configuration

Confirm that all necessary configuration values previously held in `web.config` have been transferred to `appsettings.json` and `appsettings.{Environment}.json` files, including:

- Connection strings
- Application-specific settings
- Logging configuration

### 9. Validate Static Files and Middleware

If `Bookstore.Web` serves static files or uses middleware, confirm that the `Program.cs` or `Startup.cs` file correctly configures:

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();
```

Ensure the middleware pipeline order is correct, as incorrect ordering is a common source of runtime issues in ASP.NET Core applications.