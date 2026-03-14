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

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database as expected. If Entity Framework is in use, verify that migrations apply correctly using `dotnet ef database update`.
- **Domain logic**: Exercise the core domain features through the UI or API endpoints to confirm expected behavior.
- **Static assets and routing**: Confirm that pages render correctly and that routing behaves as expected under the new runtime.

### 5. Review Removed or Changed APIs

Cross-platform .NET removes or alters certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues that would not appear as build errors:

- **`System.Web` dependencies**: Any code that previously relied on `System.Web` may need to be replaced with ASP.NET Core equivalents.
- **Configuration**: Confirm that `Web.config`-based configuration has been properly replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` system.
- **Authentication and authorization**: Verify that any membership or identity-related functionality works correctly under ASP.NET Core Identity or whichever replacement was adopted.
- **HTTP context access**: Ensure that any access to `HttpContext` uses the ASP.NET Core patterns, such as `IHttpContextAccessor`.

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 7. Review NuGet Package Versions

Confirm that all NuGet packages referenced across the three projects are compatible with the target framework. Pay particular attention to:

- Entity Framework Core version alignment across `Bookstore.Data` and `Bookstore.Domain`.
- Any third-party libraries that may have separate .NET Framework and .NET Core packages.