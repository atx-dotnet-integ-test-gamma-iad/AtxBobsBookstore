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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Runtime Behavior

Some issues do not surface at compile time. Pay attention to the following areas at runtime:

- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm the correct version (EF Core) is referenced and that migrations are compatible. Run the application against a development database and verify that queries and schema operations work as expected.
- **Configuration**: Confirm that `appsettings.json` is correctly replacing any legacy `Web.config` or `App.config` entries, including connection strings and application settings.
- **Authentication and Authorization**: If the web project uses ASP.NET Identity or any middleware, verify that it initializes and functions correctly under ASP.NET Core.
- **Static Files and Routing**: Confirm that static assets are served correctly and that all routes resolve as expected.

### 5. Run the Application Locally

Start the web application locally and manually exercise the primary workflows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and verify that pages load, data is retrieved and persisted correctly, and no unhandled exceptions occur.

### 6. Check for Removed or Changed APIs

Review the code in all three projects for any use of APIs that exist in .NET but behave differently from .NET Framework. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced during transformation.
- `HttpContext` usage, which should now go through dependency injection in ASP.NET Core.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

### 7. Validate the Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Publish the Application

Once local validation is complete, produce a published output to confirm the application can be packaged correctly:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.