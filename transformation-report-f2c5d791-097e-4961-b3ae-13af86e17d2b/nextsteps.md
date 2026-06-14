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

Verify that no warnings or errors appear during restoration, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced during the migration or a pre-existing issue.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Check that the connection string in `appsettings.json` (or equivalent configuration file) is correct for the target environment.
- If the project uses Entity Framework Core, run the following to verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application and verify that it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages or endpoints that interact with the data layer.

### 6. Review Configuration Files

Confirm that the following have been correctly updated for cross-platform .NET:

- `appsettings.json` and `appsettings.Development.json` contain valid configuration values.
- Any file paths used in configuration or code use `Path.Combine` or forward-slash-compatible formats rather than hardcoded Windows-style backslashes.
- Authentication, authorization, and middleware configurations in `Program.cs` or `Startup.cs` are intact and functional.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining platform-specific dependencies that may not have been addressed during the transformation:

- References to Windows-only APIs such as the registry, COM interop, or `System.Windows`.
- Any third-party libraries that do not support the target .NET version. Cross-reference these against [NuGet](https://www.nuget.org) or the library's documentation.

### 8. Deploy to Target Environment

Once local validation is complete, publish the application for the target environment:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and configure the hosting environment (e.g., IIS, Kestrel, or a reverse proxy such as Nginx) as appropriate for your infrastructure.