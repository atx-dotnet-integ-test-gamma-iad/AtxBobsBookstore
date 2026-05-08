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

Check the output for any warnings that may indicate compatibility issues even if the build succeeds, such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, exercise the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply and queries execute as expected.
- **File paths**: Ensure any file I/O operations in the project use `Path.Combine` or similar cross-platform APIs rather than hardcoded backslash-separated paths.
- **Configuration**: Confirm that `appsettings.json` (or equivalent) is being read correctly and that any legacy `Web.config` or `App.config` values have been properly migrated.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or similar mechanisms, verify that login, registration, and role-based access work as expected.

### 5. Review Replaced or Removed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Confirm that all usages have been replaced with ASP.NET Core equivalents.
- **WCF or Remoting**: If any of these were present in the original project, confirm they have been replaced with supported alternatives.
- **`ConfigurationManager`**: If used in `Bookstore.Data` or `Bookstore.Domain`, confirm it has been replaced with `Microsoft.Extensions.Configuration`.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` element is set to a currently supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm the targeted version is not end-of-life.

### 7. Review NuGet Package Versions

Check that all NuGet packages referenced across the three projects are targeting compatible versions for the selected .NET version. Pay particular attention to:

- Entity Framework or Entity Framework Core packages
- Any third-party libraries that may have separate packages for .NET Framework versus cross-platform .NET