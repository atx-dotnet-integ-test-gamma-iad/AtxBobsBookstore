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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate areas of concern such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results carefully. Any failing tests should be investigated before proceeding.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Areas to verify manually include:

- Application startup and landing page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json` are correct for the target environment)
- Domain logic correctness by exercising key application workflows (e.g., browsing, searching, or managing books depending on the application's features)
- Any authentication or authorization flows if present

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid and point to the correct database instances
- Any file paths that were previously Windows-specific (e.g., using backslashes) have been updated to use cross-platform equivalents or `Path.Combine`
- Logging configuration is appropriate for the target environment

### 6. Check for Platform-Specific Code

Even without build errors, there may be runtime issues caused by platform-specific APIs that compile successfully on .NET but fail at runtime on non-Windows systems. Review the codebase for:

- Use of `System.Drawing` (GDI+), which has limited support outside Windows
- Windows registry access via `Microsoft.Win32.Registry`
- Any P/Invoke calls targeting Windows-only native libraries
- Hardcoded Windows-style file paths

### 7. Review Target Framework

Confirm that all projects are targeting a currently supported version of .NET. Open each `.csproj` file and verify the `<TargetFramework>` element reflects an appropriate and supported version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting an older version such as `net6.0`, consider upgrading to a longer-supported release.

### 8. Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```