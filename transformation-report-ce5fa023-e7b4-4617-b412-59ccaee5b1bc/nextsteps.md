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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework version or by pre-existing issues.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints
- Any authentication or authorization flows still function correctly

### 5. Review Configuration Files

Compare the transformed `appsettings.json` and any environment-specific configuration files against the original `Web.config` or `App.config` files to ensure all settings were carried over correctly. Pay particular attention to:

- Connection strings
- Application-specific keys or settings
- Logging configuration

### 6. Check for Platform-Specific APIs

Search the codebase for any remaining usage of Windows-specific APIs that may compile successfully but fail at runtime on non-Windows platforms. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Identity or Windows Authentication
- File path assumptions using backslashes

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

### 7. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output targets the intended runtime framework before deploying to the target environment.