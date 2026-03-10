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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs, missing references, or compatibility concerns that did not surface as hard errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Pay close attention to any tests that cover data access logic in `Bookstore.Data` or domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the data layer connects correctly to the target database. Check the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date. Run the following if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6) and was migrated to EF Core, manually test all critical queries and data operations to confirm expected behavior, as EF Core has behavioral differences from EF6.

### 5. Run the Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without runtime exceptions.
- Pages load and render correctly.
- Data reads and writes function as expected.
- Authentication and authorization flows work if applicable.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All settings previously in `Web.config` or `App.config` have been moved to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- No references to `System.Configuration.ConfigurationManager` remain unless the `System.Configuration.ConfigurationManager` NuGet package has been explicitly added.

### 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET, including:

- `System.Web` references, which are not available outside of ASP.NET Core.
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-only file path assumptions (backslashes, drive letters).
- `AppDomain` usage beyond what is supported in .NET Core and later.

### 8. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all projects unless there is a specific reason for them to differ.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and the compiled assemblies.

### 3. Deploy to the Target Environment

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the appropriate hosting bundle from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).