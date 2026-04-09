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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate areas of concern such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Start the `Bookstore.Web` project and manually verify core application functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, run or verify any pending migrations:
  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```
- **File paths**: Ensure no hardcoded Windows-style paths (`\`) exist in the codebase. Replace them with `Path.Combine()` or forward-slash equivalents where applicable.
- **Configuration**: Confirm that `appsettings.json` values, connection strings, and environment-specific settings load correctly under the new hosting model.
- **Authentication and Session**: If the application uses authentication, verify that cookies, tokens, or session state behave as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 6. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas include:

- `System.Web` namespace references (not available in cross-platform .NET)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- Windows-specific APIs such as the registry or certain `System.Drawing` methods

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining compatibility concerns.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to the target environment.