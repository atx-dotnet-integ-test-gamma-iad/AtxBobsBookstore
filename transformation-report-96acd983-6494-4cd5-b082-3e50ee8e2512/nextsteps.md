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

Inspect each project for any remaining dependencies that are Windows-only. Common areas to check:

- NuGet packages that rely on `System.Web`
- Usage of `Microsoft.Web.*` namespaces
- Any P/Invoke calls or references to Windows registry APIs
- `Bookstore.Web` in particular should be reviewed if it was previously an ASP.NET Web Forms or MVC 5 application, as these do not run on cross-platform .NET

### 5. Run Unit Tests

If the solution contains test projects, execute them to verify runtime behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by the migration or pre-existing issues.

### 6. Run the Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, and any data access features provided by `Bookstore.Data` and `Bookstore.Domain`.

### 7. Verify Database Connectivity

Since `Bookstore.Data` handles data access, confirm the following:

- The connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If the project previously used Entity Framework 6, confirm whether it was migrated to Entity Framework Core, as EF6 has limited support on cross-platform .NET

### 8. Test on a Non-Windows Platform

If cross-platform compatibility is a primary goal, run and test the application on Linux or macOS to surface any remaining platform-specific issues that would not appear during Windows-based testing.