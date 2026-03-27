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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the transformation:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Verify that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- If the project uses migrations, run the following to confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and test primary user flows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for any runtime exceptions that would not surface during compilation.

### 6. Review Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings, replacing any values that were previously stored in `Web.config` or `App.config`.
- Ensure environment-specific settings (e.g., `appsettings.Development.json`) are configured appropriately.

### 7. Check for Removed or Changed APIs

Review the codebase for any usage of APIs that behave differently in cross-platform .NET compared to .NET Framework. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry or certain cryptography providers.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 8. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy them to the target hosting environment, ensuring the correct .NET runtime version is installed on the host.