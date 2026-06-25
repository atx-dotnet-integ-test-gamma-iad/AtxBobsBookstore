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

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually navigate through the application and verify the following:

- Pages load without errors
- Data access operations (reads and writes) function correctly through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves as expected

### 5. Check for Platform-Specific API Usage

Even without build errors, some APIs that were available in .NET Framework may behave differently or have limited support in cross-platform .NET. Review the following areas:

- **Configuration**: Ensure `Web.config` or `App.config` settings have been migrated to `appsettings.json` and are being read correctly via `IConfiguration`.
- **Database connectivity**: Confirm that any connection strings and database providers (e.g., Entity Framework Core) are correctly configured for the target platform.
- **File system paths**: Check that any file path handling uses `Path.Combine` and does not rely on Windows-specific path separators.
- **Authentication/Authorization**: If the application uses Windows Authentication or other Windows-specific mechanisms, verify that equivalent cross-platform alternatives are in place.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

### 7. Review NuGet Package Versions

Check that all NuGet packages referenced across the three projects are compatible with the target framework. Pay particular attention to:

- Any packages that were previously targeting `.NET Framework` only
- Packages that have been superseded by built-in .NET APIs

You can use the following command to list outdated packages:

```bash
dotnet list package --outdated
```

Update packages where appropriate and re-run the build and tests after doing so.