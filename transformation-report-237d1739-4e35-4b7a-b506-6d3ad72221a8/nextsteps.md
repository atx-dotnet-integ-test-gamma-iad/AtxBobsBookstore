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

Review the output for any warnings related to package compatibility or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that the build output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If the project uses Entity Framework, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the core business logic paths through the UI or API endpoints to confirm expected behavior.
- **Configuration**: Verify that `appsettings.json` contains all required configuration values that may have previously been stored in `Web.config` or `App.config` files.

### 5. Check for Windows-Specific API Usage

Even without build errors, there may be runtime issues caused by Windows-specific APIs that are not available on other platforms. Use the .NET Compatibility Analyzer to identify potential issues:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Review any analyzer warnings and replace Windows-specific APIs with cross-platform equivalents where applicable.

### 6. Review Target Framework

Open each `.csproj` file and confirm that the `TargetFramework` is set to a current and supported version of .NET, such as `net8.0`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If an older version such as `net6.0` or `net7.0` is present, consider upgrading to `net8.0` as those versions are no longer receiving long-term support.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the following areas if they are used in the project:

- `System.Web` namespace references (not available in .NET Core/5+)
- `HttpContext` usage outside of the request pipeline
- `ConfigurationManager` (replaced by `IConfiguration`)
- WCF server-side components
- Any third-party libraries that have not been updated for .NET 5+