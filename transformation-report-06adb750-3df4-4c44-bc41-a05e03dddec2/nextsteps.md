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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a supported cross-platform .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`) rather than a legacy `net48` or `netcoreapp` value.

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the transformation:

```bash
dotnet test --configuration Release
```

Address any failing tests before proceeding further.

### 5. Check Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Connection strings in `appsettings.json` are valid and accessible from the target environment.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any pages that interact with the domain and data layers.

### 7. Review Configuration Files

Confirm that the following configuration concerns have been addressed:

- `Web.config` has been replaced or supplemented by `appsettings.json` where applicable.
- Any environment-specific settings (connection strings, API keys) are correctly placed and not hardcoded.
- Middleware configuration in `Program.cs` or `Startup.cs` reflects the expected behavior of the original application.

### 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or references that may cause issues on non-Windows platforms:

- `System.Web` references should be fully removed.
- Any use of `Registry`, `WindowsIdentity`, or similar APIs should be reviewed and replaced with cross-platform alternatives if cross-platform deployment is required.

### 9. Review Logging and Error Handling

Confirm that logging has been migrated from any legacy provider (e.g., `log4net`, `NLog` tied to `System.Web`) to a compatible provider such as `Microsoft.Extensions.Logging`, and that unhandled exceptions are surfaced appropriately.