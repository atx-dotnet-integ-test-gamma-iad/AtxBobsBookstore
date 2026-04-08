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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise the core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that all queries return expected results. Pay attention to any Entity Framework provider changes that may have occurred during migration.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` produce the same results as the legacy application.
- **Web layer**: Navigate through the application and confirm that all pages render correctly, form submissions work, and no runtime exceptions are thrown.

### 5. Check for Removed or Changed APIs

Cross-platform .NET removed several APIs that were available in .NET Framework. Review the following areas:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET. These should have been replaced with ASP.NET Core equivalents.
- `ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- `HttpContext.Current` should be replaced with injected `IHttpContextAccessor`.
- Binary serialization (`BinaryFormatter`) is disabled by default and should be replaced with a supported alternative.

Run the .NET Upgrade Assistant compatibility analyzer if any runtime issues are encountered:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Review Application Configuration

- Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`.
- Verify connection strings are correctly formatted for the target database provider.
- Check that any environment-specific configuration is handled using `appsettings.{Environment}.json` files.

### 7. Validate Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.