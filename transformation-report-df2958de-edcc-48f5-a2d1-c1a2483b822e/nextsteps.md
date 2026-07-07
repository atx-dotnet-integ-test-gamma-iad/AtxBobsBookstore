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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that your data access layer is functioning correctly:

- Confirm that the correct version of Entity Framework (Core) is referenced and compatible with your new target framework.
- If migrations are used, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and confirm that pages load correctly.
- Test any forms, data submissions, and database-driven pages.
- Check the console output and application logs for runtime exceptions or deprecation warnings.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, authentication settings, and any environment-specific values have been correctly migrated.
- Ensure that `appsettings.Development.json` and `appsettings.Production.json` are configured appropriately for each environment.

### 7. Check for Removed or Changed APIs

Review the code for any use of APIs that exist in .NET but behave differently from .NET Framework. Common areas to check include:

- `System.Web` dependencies, which are not available in cross-platform .NET.
- HTTP context access patterns, which differ between ASP.NET and ASP.NET Core.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.