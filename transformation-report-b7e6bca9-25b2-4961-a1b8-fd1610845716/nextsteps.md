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

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Verify that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and confirm that pages load without errors.
- Test key user flows such as browsing, searching, and any data entry forms.
- Review the console output and application logs for runtime exceptions or deprecation warnings.

### 6. Review `web.config` and `appsettings.json`

Legacy ASP.NET applications used `web.config` for configuration. In cross-platform .NET, configuration is handled through `appsettings.json`. Confirm that:

- Connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- No critical configuration values remain only in a `web.config` file.

### 7. Check for Platform-Specific API Usage

Run the .NET compatibility analyzer to surface any APIs that may behave differently or are unavailable on non-Windows platforms:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Address any warnings related to platform-specific APIs, particularly in `Bookstore.Data` and `Bookstore.Web`, if cross-platform deployment on Linux or macOS is intended.

### 8. Deployment

Once all validation steps pass, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to the target environment according to your hosting setup (IIS, Kestrel, Azure App Service, etc.).