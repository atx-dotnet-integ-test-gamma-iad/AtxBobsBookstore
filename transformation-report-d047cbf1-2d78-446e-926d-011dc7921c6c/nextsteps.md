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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing before deployment.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Start the web application locally and perform manual verification of core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise key domain operations through the UI or API endpoints to confirm expected behavior.
- **Configuration**: Ensure that any configuration previously stored in `Web.config` has been correctly migrated to `appsettings.json` or environment variables.

### 5. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs or libraries that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Review the following:

- Any use of the `Microsoft.Win32` namespace or Windows registry access.
- File path construction — ensure `Path.Combine` is used rather than hardcoded backslashes.
- Any third-party NuGet packages that may have been targeting .NET Framework. Verify their compatibility with the current target framework.

### 6. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is in use:

- **Entity Framework Core** is the supported version for cross-platform .NET.
- If the project was migrated from **Entity Framework 6**, review whether EF Core has been adopted or if EF6 compatibility is being relied upon.
- Run any pending migrations or verify the database schema is consistent:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected assets, configuration files, and binaries are present before deploying to the target environment.