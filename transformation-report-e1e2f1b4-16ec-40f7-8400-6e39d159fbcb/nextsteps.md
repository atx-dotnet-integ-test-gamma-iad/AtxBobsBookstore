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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences in the new runtime.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:
- Application startup and routing
- Database connectivity via `Bookstore.Data`
- Domain logic execution via `Bookstore.Domain`
- Any pages or endpoints that relied on Windows-specific APIs (e.g., `System.Drawing`, registry access, Windows authentication)

### 6. Check for Runtime Compatibility Issues

Even without build errors, certain APIs may have been removed or changed in cross-platform .NET. Review the code for usage of any of the following, which are known to behave differently or be unavailable outside of Windows:

- `System.Drawing` (use a replacement such as `SkiaSharp` or `ImageSharp` if needed)
- `Microsoft.Win32` registry APIs
- Windows-specific authentication middleware
- `AppDomain.CurrentDomain.SetupInformation`

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to assist in identifying these at runtime.

### 7. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that all migrations are up to date and apply correctly against the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Validate Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and contain the correct values for connection strings, logging, and other settings that may have previously been stored in `Web.config` or `App.config`.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all expected files, static assets, and configuration files are present before deploying to the target environment.