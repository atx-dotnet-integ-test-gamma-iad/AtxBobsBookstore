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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your environment).
- Connection strings in configuration files (`appsettings.json`) are valid and accessible in the target environment.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 5. Verify Domain Logic

Review `Bookstore.Domain` for any types or APIs that may have been available in .NET Framework but behave differently in cross-platform .NET. Pay particular attention to:

- `System.Configuration` usage, which is not available by default in .NET and should be replaced with `Microsoft.Extensions.Configuration`.
- Any serialization logic using `BinaryFormatter`, which is disabled in .NET 5 and later.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- All routes and pages load correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static files (CSS, JavaScript, images) are served correctly.

### 7. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all settings that were previously held in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Logging configuration
- Application-specific settings

### 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs that may cause issues on non-Windows environments:

- `Microsoft.Win32` namespace usage
- `System.Drawing` (use `System.Drawing.Common` with awareness of its Linux limitations)
- COM interop or P/Invoke calls targeting Windows libraries