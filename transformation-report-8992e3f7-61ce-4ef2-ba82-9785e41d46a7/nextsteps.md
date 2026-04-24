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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that the build output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup and landing page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json` for any legacy or Windows-specific values)
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files for the following:

- Connection strings that may reference SQL Server with Windows Authentication (`Integrated Security=True`), which may not function on non-Windows environments
- Any file paths that use Windows-style backslashes (`\`) rather than forward slashes or `Path.Combine`
- Any references to Windows-specific features such as the Windows registry or Windows identity

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a supported cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 7. Review Removed Windows-Specific Dependencies

Check that no remaining NuGet packages or API calls depend on Windows-only libraries, such as:

- `System.Web`
- `Microsoft.Web.Infrastructure`
- Windows Communication Foundation (WCF) server-side components
- Any package with a `windows` target framework suffix that is not intentional

### 8. Deploy to Target Environment

Once all validation steps pass, publish the application targeting your intended runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and configure the web server (such as IIS with the ASP.NET Core Module, or Nginx/Apache on Linux) to host the application.