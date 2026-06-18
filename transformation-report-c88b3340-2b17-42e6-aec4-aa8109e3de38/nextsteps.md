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

Check the build output for any warnings that, while non-blocking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. Pay attention to any Entity Framework provider changes that may have been made during transformation.
- **File paths**: Ensure no hardcoded Windows-style file paths (`\`) exist in the codebase. Cross-platform .NET requires the use of `Path.Combine` or forward slashes.
- **Configuration**: Verify that `appsettings.json` or equivalent configuration files are being read correctly, particularly connection strings and environment-specific settings.
- **Authentication and Session**: If the application uses authentication, confirm that cookies, sessions, or token handling work as expected under the new hosting model.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available outside of ASP.NET Core
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any use of `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`

### 7. Deployment

Once the application has been validated locally, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required static assets, configuration files, and binaries are present before deploying to the target environment.