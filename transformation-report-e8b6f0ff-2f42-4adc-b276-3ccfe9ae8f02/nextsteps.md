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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project locally and manually exercise the core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to and query the database. Pay attention to any connection string changes that may be required for the target environment.
- **File paths**: Ensure that any file system operations use `Path.Combine` or equivalent cross-platform path handling rather than hardcoded backslashes.
- **Configuration**: Verify that `appsettings.json` (or equivalent) is being read correctly and that any values previously stored in `Web.config` or `App.config` have been migrated appropriately.
- **Authentication and Authorization**: If the application uses any authentication middleware, confirm it is functioning as expected under the new runtime.

### 5. Review Migrated Project Files

Open each `.csproj` file and confirm the following:

- The target framework moniker is set to the intended version, for example `net8.0`.
- No unnecessary or legacy package references remain, such as packages targeting `net4x` only.
- Any `<PackageReference>` entries that replaced older `packages.config` entries are resolving to compatible versions.

### 6. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to scan for any remaining usage of Windows-only APIs, particularly within `Bookstore.Data` and `Bookstore.Domain`:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze app/Bookstore.Web/Bookstore.Web.csproj
```

Address any flagged APIs that are not supported on Linux or macOS if cross-platform deployment is intended.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assemblies, static assets, and configuration files are present before deploying to the target environment.