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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly in Release configuration:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs, missing references, or compatibility concerns that did not surface as hard errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 5. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key workflows of the application, such as browsing, searching, and any data entry flows, to confirm that runtime behavior matches expectations.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently on cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **Data access**: If Entity Framework is used, confirm the correct version of EF Core is referenced and that migrations are up to date.
- **Configuration**: `System.Configuration.ConfigurationManager` is not available by default in .NET. Confirm that configuration has been migrated to `Microsoft.Extensions.Configuration` and that `appsettings.json` is present and correct.
- **Authentication and Authorization**: If ASP.NET Membership or older authentication mechanisms were used, confirm they have been replaced with ASP.NET Core Identity or equivalent.
- **File paths**: Confirm that any hardcoded file path separators (`\`) have been replaced with `Path.Combine` or `Path.DirectorySeparatorChar` for cross-platform compatibility.

### 7. Review Removed Windows-Specific Dependencies

Check all three projects for any remaining references to Windows-specific libraries or packages. These will not cause build errors on Windows but will fail at runtime on Linux or macOS. Common examples include:

- `System.Drawing.Common` (requires additional native libraries on non-Windows platforms)
- COM interop references
- Windows Registry access via `Microsoft.Win32.Registry`

### 8. Database Migrations

If the project uses Entity Framework Core, verify that the database schema is consistent with the current model:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a development database before deploying:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files, static assets, and configuration files are present before deploying to the target environment.