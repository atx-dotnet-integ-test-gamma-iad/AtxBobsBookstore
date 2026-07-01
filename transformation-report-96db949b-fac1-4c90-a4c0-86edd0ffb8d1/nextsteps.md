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

Review the output to confirm all three projects build with zero errors and note any warnings that may require attention.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken by the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly using `dotnet ef database update`.
- **Domain logic**: Exercise the core domain operations through the UI or API endpoints to confirm expected behavior.
- **Configuration**: Ensure that any settings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` and are being read at runtime.
- **Static assets and routing**: Navigate through the web application to confirm that pages, routes, and static files resolve correctly.

### 5. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues that would not surface as build errors:

- **`System.Web` dependencies**: Any code that relied on `System.Web` types may have been replaced or removed. Verify that HTTP context access, session handling, and authentication work as expected.
- **Windows-specific APIs**: If any code uses Windows Registry, Windows Identity, or other platform-specific APIs, test on the target deployment platform to confirm compatibility.
- **Third-party libraries**: Confirm that all NuGet packages in use have versions compatible with the target .NET version and that no packages were silently downgraded or excluded during transformation.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it targets the appropriate web-specific moniker if applicable:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Review Warnings

Even without errors, build warnings may indicate deprecated APIs or compatibility concerns. Run the build with detailed output to review all warnings:

```bash
dotnet build --configuration Release --verbosity normal
```

Address any warnings related to nullable reference types, obsolete members, or platform compatibility analyzers.