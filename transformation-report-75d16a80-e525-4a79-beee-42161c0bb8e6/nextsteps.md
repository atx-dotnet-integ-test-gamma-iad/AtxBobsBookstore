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

Run a full solution build to confirm the absence of any build errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility issues that could cause runtime problems.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken by the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and currently supported version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still within its support window.

### 5. Verify Runtime Behavior

Start the `Bookstore.Web` application locally and manually exercise the core workflows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas, as they are common sources of subtle runtime differences after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework (or whichever ORM is in use) migrations and queries execute correctly.
- **Configuration loading**: Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and is being read at runtime.
- **Authentication and authorization**: If the application uses any authentication middleware, confirm it initializes and behaves as expected.
- **Static assets and routing**: Navigate through the web application to confirm pages render correctly and routes resolve as expected.

### 6. Check for Platform-Specific API Usage

Even without build errors, certain APIs that were available in .NET Framework may behave differently or have reduced functionality on non-Windows platforms. Run the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific concerns:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

Review the output and address any flagged APIs before deploying to a non-Windows environment.

### 7. Review Logging and Error Handling

Confirm that the application's logging infrastructure has been migrated to use `Microsoft.Extensions.Logging` or another compatible provider. Check that unhandled exceptions are surfaced correctly in the new hosting model.