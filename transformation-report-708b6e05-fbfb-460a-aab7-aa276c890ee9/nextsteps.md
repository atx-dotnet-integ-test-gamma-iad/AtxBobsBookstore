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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new target framework or by pre-existing issues.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically check the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database and that any Entity Framework migrations are up to date. Run `dotnet ef database update` if migrations are pending.
- **Domain logic**: Exercise the key business logic paths exposed through `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application routes, forms, and any API endpoints to confirm they respond correctly.

### 5. Review Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`). Also check for any remaining references to Windows-specific packages or APIs (such as `System.Web`) that may cause runtime failures even without build errors.

### 6. Check Configuration Files

Review `appsettings.json` and any environment-specific configuration files to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously in `Web.config` have been properly migrated to `appsettings.json`.
- The application reads configuration through `IConfiguration` rather than `ConfigurationManager` where applicable.

### 7. Review Entity Framework Setup

If the project uses Entity Framework Core, confirm the following:

- The `DbContext` is registered correctly in the dependency injection container within `Program.cs` or `Startup.cs`.
- Migrations reflect the current model state. Run the following to check:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.