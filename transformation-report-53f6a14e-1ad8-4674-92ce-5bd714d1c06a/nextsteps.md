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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns with the new target framework.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that your data access layer is functioning correctly:

- Confirm that the correct version of Entity Framework (e.g., EF Core) is referenced and is compatible with your new target framework.
- If database migrations are used, run the following to verify the migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality such as page rendering, data retrieval, and form submissions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions or middleware configuration errors that would not surface at build time.

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are correct and point to the intended database.
- Any settings previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that existed in .NET Framework may behave differently or have reduced functionality in cross-platform .NET. Review the codebase for usage of the following and test them explicitly at runtime:

- `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific authentication mechanisms
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Deprecated or Suppressed Warnings

Run the build with warnings treated as errors to surface any issues that may have been suppressed:

```bash
dotnet build --configuration Release /warnaserror
```

Address any warnings that appear, as they may indicate future compatibility issues.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required assemblies, static assets, and configuration files are present.

### 3. Test Against a Staging Environment

Deploy the published output to a staging environment that mirrors production and run the same validation steps described above before promoting to production.