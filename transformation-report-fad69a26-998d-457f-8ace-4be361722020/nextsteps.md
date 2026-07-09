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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the build output for any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new target framework or pre-existing issues.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that database connections, queries, and migrations (if using Entity Framework) function correctly. If the project uses Entity Framework, run any pending migrations:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise key business logic paths to confirm expected outputs.
- **Web layer**: Navigate through the application's pages or API endpoints and confirm responses are correct.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are valid and point to the correct database instances.
- Any configuration keys that were previously stored in `Web.config` or `App.config` have been correctly migrated to the new configuration system.

### 6. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining usage of Windows-only or platform-specific APIs that may cause issues when running on Linux or macOS:

```bash
dotnet build /p:PlatformTarget=AnyCPU /p:Nullable=enable
```

Review any `CA1416` platform compatibility warnings in the output.

### 7. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no implicit framework mismatches.

### 8. Deployment

Once validation is complete, publish the application using the following command, targeting your intended runtime:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained false --output ./publish
```

Adjust the `--runtime` flag (`win-x64`, `linux-x64`, `osx-x64`, etc.) to match your deployment environment. Review the contents of the `./publish` output directory before deploying to confirm all expected files are present.