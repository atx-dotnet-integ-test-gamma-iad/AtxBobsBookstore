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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings, particularly those related to nullable reference types, deprecated APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are caused by behavioral differences in the new .NET runtime or by pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Core domain logic in `Bookstore.Domain` produces expected results
- All major routes and pages in `Bookstore.Web` load and function correctly

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are valid and point to the correct database instances
- Any file paths or environment-specific settings have been updated for the new platform
- Authentication or authorization settings, if present, are correctly configured

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior between .NET Framework and modern .NET. Review the following areas:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET (these would have caused build errors if present, but confirm they have been fully replaced)
- HTTP context access patterns in `Bookstore.Web`
- Entity Framework version compatibility in `Bookstore.Data` — confirm whether the project is using EF Core and that migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm the `TargetFramework` element reflects the intended modern .NET version (for example, `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.