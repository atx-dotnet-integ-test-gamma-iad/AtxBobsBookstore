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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected on the new runtime:

```bash
dotnet test --configuration Release
```

Review test output carefully. A passing build does not guarantee correct runtime behavior, so test coverage is important at this stage.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the key business logic paths exposed through `Bookstore.Domain` to confirm correct behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

### 6. Review Configuration Files

Check `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to confirm that connection strings, service URLs, and other settings have been correctly carried over from the legacy configuration system (e.g., `Web.config` or `App.config`).

### 7. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit the codebase for any remaining Windows-specific APIs or libraries, such as:

- `Microsoft.Win32` registry access
- Windows-only file path assumptions
- COM interop or P/Invoke calls targeting Windows DLLs

These will not cause build errors but will cause runtime failures on non-Windows platforms.

### 8. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output runs correctly in the target hosting environment.