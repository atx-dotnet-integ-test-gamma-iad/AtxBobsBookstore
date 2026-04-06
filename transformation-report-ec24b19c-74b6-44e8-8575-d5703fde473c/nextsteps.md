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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Review Target Framework

Open each `.csproj` file and verify that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all projects.

### 4. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced during the migration.

### 5. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- Any pages or API endpoints that interact with data access or business logic

### 6. Check for Windows-Specific APIs

Even without build errors, the code may contain Windows-specific APIs that will fail at runtime on non-Windows platforms. Review the codebase for usage of:

- `Microsoft.Win32` namespaces
- `System.Windows` namespaces
- Registry access
- Windows file path assumptions (e.g., hardcoded backslashes)

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 7. Verify Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before deploying:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files have been correctly carried over and that connection strings or other settings are valid for the target environment.

### 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present before deploying to the target environment.