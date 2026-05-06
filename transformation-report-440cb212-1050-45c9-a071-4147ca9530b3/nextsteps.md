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

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that all queries return expected results.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` behave consistently with the legacy version.
- **Web layer**: Navigate through the application and confirm that pages render correctly, forms submit properly, and no runtime exceptions occur.

### 5. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas for potential runtime issues:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET.
- `BinaryFormatter` usage, which is disabled by default.
- `AppDomain` APIs that have limited support.
- Any Windows-specific registry or file path assumptions.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility concerns.

### 6. Validate Configuration

Confirm that configuration files have been migrated correctly:

- Legacy `Web.config` settings should now reside in `appsettings.json` or environment variables.
- Connection strings should be verified against the target database.
- Any `<appSettings>` keys from the original project should have corresponding entries in the new configuration system.

### 7. Review Logging and Error Handling

Ensure that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider. Check that unhandled exceptions are surfaced appropriately in the new runtime environment.

### 8. Perform a Database Migration Check

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and apply cleanly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the schema matches expectations after the migration is applied.