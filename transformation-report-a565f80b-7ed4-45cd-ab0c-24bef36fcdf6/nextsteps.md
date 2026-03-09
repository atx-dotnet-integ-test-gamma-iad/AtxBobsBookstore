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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns that did not surface as hard errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether the failure is due to the migration or a pre-existing issue.

### 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, verify that the data access layer is functioning correctly:

- Confirm that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- If the project uses migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Check the console output and application logs for any runtime exceptions or warnings.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Development.json` contain the correct connection strings and application settings for the target environment.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` entries or environment variables.

### 7. Check for Remaining Platform-Specific Dependencies

Even without build errors, review the project references and NuGet packages for any libraries that may only function correctly on Windows. Tools such as the .NET Upgrade Assistant compatibility analyzer or the `ApiPort` tool can assist with this review.

### 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version.

## Deployment

Once all validation steps above pass without errors:

1. Publish the web application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory contain all expected files.
3. Deploy the contents of the publish output to your target hosting environment (e.g., IIS, Linux server, Azure App Service).
4. Confirm the deployed application connects to the production database and functions correctly by running through the primary application workflows in the target environment.