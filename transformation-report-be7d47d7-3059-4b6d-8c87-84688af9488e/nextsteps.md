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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas where the migration introduced subtle issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failing tests after a migration often point to behavioral differences between .NET Framework and modern .NET, such as changes in serialization, globalization defaults, or HTTP handling.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise its core features:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, run any pending migrations and verify the schema.
- **Configuration loading**: Ensure `appsettings.json` (and environment-specific variants) are loading correctly, replacing any legacy `Web.config` or `App.config` values that may have been migrated.
- **Authentication and authorization**: If the application uses ASP.NET Identity or cookie-based auth, verify login and session behavior.
- **Static files and routing**: Confirm that pages, assets, and API routes resolve as expected.

### 5. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs that may compile successfully but fail at runtime on non-Windows environments:

- `System.Web` references
- `Registry` access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage

```bash
grep -rn "System.Web\|Registry\|HttpContext.Current" app/
```

Replace any identified usages with their cross-platform equivalents.

### 6. Review Transformed Configuration Files

Compare the generated `appsettings.json` against the original `Web.config` or `App.config` to confirm that all connection strings, application settings, and custom configuration sections were carried over accurately.

### 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.