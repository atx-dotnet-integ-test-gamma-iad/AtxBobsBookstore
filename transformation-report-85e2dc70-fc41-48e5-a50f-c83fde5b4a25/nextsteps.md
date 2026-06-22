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

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm expected behavior.
- **Web layer**: Navigate through the application pages or endpoints and confirm that routing, middleware, and responses are functioning correctly.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm the following:

- Application settings have been migrated to `appsettings.json`.
- Any environment-specific configuration is handled via `appsettings.{Environment}.json` or environment variables.
- Connection strings are correctly defined and accessible at runtime.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that were available in .NET Framework may behave differently or have limited support in cross-platform .NET. Review the codebase for usage of the following and test them explicitly at runtime:

- `System.Web` references or types
- Windows-specific registry or file path assumptions
- COM interop or Windows-only libraries
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 7. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects in the solution.

### 8. Publish the Application

Once runtime validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.