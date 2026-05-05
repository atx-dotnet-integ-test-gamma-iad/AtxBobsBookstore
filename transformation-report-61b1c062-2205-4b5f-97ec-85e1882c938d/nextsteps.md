# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Build Status

The solution transformation appears to have completed successfully. No build errors were detected across any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or missing transitive dependencies.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-breaking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If test projects exist in the solution, execute them to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test
```

Review test results carefully. Any failing tests that previously passed may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that your data access layer functions correctly:

- Check that your connection strings in `appsettings.json` are correctly configured for your target environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as page rendering, data retrieval, and form submissions behave as expected.

### 6. Check for Platform-Specific Code

Even with a successful build, review the codebase for any APIs that were available in .NET Framework but may behave differently on cross-platform .NET. Common areas to inspect include:

- `System.Web` references or any remaining usage that may have been shimmed during transformation.
- File path handling — ensure `Path.Combine` is used rather than hardcoded backslashes.
- Registry access or Windows-specific APIs that may not function on non-Windows environments.
- Configuration — confirm migration from `Web.config` or `App.config` to `appsettings.json` is complete and all keys are accounted for.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects in the solution.

### 8. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy the output to your target hosting environment, ensuring the correct .NET runtime version is installed on the host.