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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors are reported during the restore process.

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

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm expected output.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

### 5. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET and should have been replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager` usage, which should be replaced with `Microsoft.Extensions.Configuration`.
- Any Windows-specific APIs (registry access, COM interop, etc.) that may compile but fail at runtime on non-Windows platforms.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to perform a more thorough API compatibility check.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a long-term support (LTS) version is required for your environment, ensure the selected version aligns with that requirement.

### 7. Review NuGet Package Versions

Check that all NuGet packages referenced in the projects are compatible with the target framework. Outdated or incompatible packages can cause runtime failures even when the build succeeds. Use the following command to identify outdated packages:

```bash
dotnet list package --outdated
```

Update packages as appropriate, taking care to review changelogs for any breaking changes.