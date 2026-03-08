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

Verify that all three projects build without warnings or errors.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all projects:

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

### 4. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- Migrations are present and up to date:
  ```bash
  dotnet ef migrations list --project Bookstore.Data
  ```
- The database can be updated successfully:
  ```bash
  dotnet ef database update --project Bookstore.Data
  ```
- Connection strings in `appsettings.json` are correctly configured for the target environment.

### 5. Run Unit Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test
```

Review test results to confirm that domain logic and data access behave as expected after the transformation.

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output for any runtime exceptions or middleware configuration issues.
- Review any areas that previously relied on Windows-specific APIs (e.g., `System.Web`, Windows Authentication, MSMQ) and confirm they have been replaced with cross-platform equivalents.

### 7. Review Configuration

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` files contain all required configuration values.
- Verify that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to the ASP.NET Core configuration system.

### 8. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target machine has the appropriate .NET runtime installed, which can be verified with:

```bash
dotnet --info
```