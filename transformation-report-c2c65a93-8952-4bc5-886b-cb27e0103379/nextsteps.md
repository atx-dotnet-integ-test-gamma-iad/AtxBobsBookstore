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

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the transformation:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly:

- Verify that your database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is compatible with the target .NET version.
- If the project uses EF Core migrations, run the following to confirm migrations are intact:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Test the database connection by running the application and performing basic data operations.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify that pages render correctly.
- Check for any runtime exceptions that would not surface at build time, such as missing configuration values, changed API behavior, or middleware issues.

### 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment variables.
- Any legacy `<system.web>` or `<appSettings>` entries from `Web.config` have been accounted for in the new configuration system.
- Authentication, authorization, and session configuration has been correctly translated to the ASP.NET Core middleware pipeline if applicable.

### 7. Review Namespace and API Changes

Some .NET Framework APIs do not exist or have changed in cross-platform .NET. Manually review the following areas:

- Any use of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage, which has changed in ASP.NET Core.
- Any Windows-specific APIs (e.g., registry access, Windows identity impersonation) that may not function on non-Windows platforms.

### 8. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.