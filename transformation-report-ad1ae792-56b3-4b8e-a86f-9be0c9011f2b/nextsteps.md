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

Check the output for any warnings that, while non-blocking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct for your target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify that it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually test core workflows such as browsing books, authentication (if applicable), and any data entry forms.

### 6. Review Configuration Files

Check the following files in `Bookstore.Web` for any values that may have been carried over from the legacy project and are no longer valid in cross-platform .NET:

- `appsettings.json` and `appsettings.Development.json`
- Any remaining `web.config` entries that should have been migrated to `appsettings.json` or middleware configuration in `Program.cs`

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 8. Review Target Framework

Confirm that all projects are targeting a supported and consistent .NET version. Open each `.csproj` file and verify the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

## Deployment

### 1. Publish the Application

Publish the web application to a folder for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm that all required files are present, including static assets, configuration files, and the compiled binaries.

### 3. Test the Published Output

Run the published application directly to confirm it behaves identically to the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```

Verify the application starts without errors and that all routes and data access operations function correctly against the target database.