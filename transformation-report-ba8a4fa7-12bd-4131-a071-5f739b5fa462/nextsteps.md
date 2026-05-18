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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- **Data access**: Confirm that database connections and queries function correctly. If Entity Framework is in use, verify that migrations are compatible with the new runtime.
- **Configuration**: Ensure that `appsettings.json` contains all settings that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or any middleware-based auth, verify that login, logout, and role-based access work correctly.
- **Static assets**: Confirm that CSS, JavaScript, and image files are served correctly.
- **Routing**: Navigate through the application to verify all routes resolve as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

### 6. Check for Removed or Changed APIs

Review any use of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET
- `HttpContext` usage patterns
- `ConfigurationManager`, which should be replaced with `IConfiguration`
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

### 7. Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are intact and apply cleanly against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project was previously using Entity Framework 6, confirm whether it has been migrated to Entity Framework Core, as there are API differences that may require code changes.

### 8. Deployment

Once all validation steps pass, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment, such as IIS, Azure App Service, or a Linux-based web server. Ensure the hosting environment has the correct .NET runtime version installed.