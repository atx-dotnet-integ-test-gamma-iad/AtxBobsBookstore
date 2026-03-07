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

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET
- Windows Registry access (`Microsoft.Win32.Registry`)
- WCF server-side components
- Any P/Invoke calls targeting Windows-specific DLLs

Run the .NET Upgrade Assistant compatibility analyzer if a deeper audit is needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze
```

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and cross-platform .NET.

### 6. Validate the Web Application at Runtime

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify the following areas:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (check connection strings in `appsettings.json`)
- Domain logic correctness through the UI or API endpoints

### 7. Review Configuration Files

Ensure that any configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Database connection strings
- Application-specific settings
- Authentication or authorization configuration

### 8. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core version is referenced and that any pending migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations against your target database before testing data access functionality.