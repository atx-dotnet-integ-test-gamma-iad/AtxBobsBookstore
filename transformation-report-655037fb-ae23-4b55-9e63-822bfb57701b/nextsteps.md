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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database and performs reads and writes correctly. Pay attention to any Entity Framework provider changes that may have occurred during migration.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` produce the same results as the legacy application.
- **Web layer**: Navigate through the application UI or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `system.web` entries have been replaced with their ASP.NET Core equivalents in `Program.cs` or `Startup.cs`.

### 6. Check for Removed or Changed APIs

Some .NET Framework APIs are not available or behave differently in cross-platform .NET. Review the following:

- Any use of `System.Web` namespaces, which are not available in ASP.NET Core.
- `HttpContext` usage, which must go through dependency injection in ASP.NET Core.
- Any Windows-specific APIs (e.g., registry access, Windows authentication) that may require additional configuration or replacement on non-Windows platforms.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assemblies and static assets are present before deploying to the target environment.