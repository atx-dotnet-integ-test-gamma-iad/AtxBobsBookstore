# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failures before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the core features of the application, including:

- Browsing and searching for books
- Any data access operations driven by `Bookstore.Data`
- Any domain logic driven by `Bookstore.Domain`

Check the console output and application logs for any runtime exceptions or unexpected behavior.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility mismatches between assemblies.

### 6. Review Removed Windows-Specific Dependencies

Check each project for any references that were previously Windows-specific, such as:

- `System.Web` references
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

If any such references remain, replace them with their cross-platform .NET equivalents.

### 7. Database and Data Layer Verification

If `Bookstore.Data` uses Entity Framework, confirm the correct EF Core provider is referenced and that any pending migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations against your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Configuration File Review

Verify that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Confirm that connection strings, application settings, and environment-specific values are present and correct.

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is clean:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files are present, then deploy the contents to your target hosting environment.