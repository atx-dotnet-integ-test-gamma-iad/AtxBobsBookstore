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

Check the output for any warnings that, while non-breaking, may indicate areas needing attention, such as nullable reference warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations apply cleanly with `dotnet ef database update`.
- **File paths**: Ensure no hardcoded Windows-style paths (`\`) exist in the codebase. Replace any with `Path.Combine` or forward-slash equivalents.
- **Configuration**: Confirm that `appsettings.json` is loading correctly and that any values previously stored in `Web.config` or `App.config` have been properly migrated.
- **Authentication and Authorization**: If the application uses ASP.NET Identity or Windows Authentication, verify that the behavior is correct under the new runtime.
- **Static assets**: Confirm that CSS, JavaScript, and image assets are being served correctly.

### 5. Review Replaced APIs

Cross-platform .NET does not support certain .NET Framework APIs. Review the codebase for any usage of the following and replace as needed:

- `System.Web` namespace references (should have been replaced with ASP.NET Core equivalents)
- `HttpContext.Current` (use dependency-injected `IHttpContextAccessor` instead)
- `ConfigurationManager` (use `IConfiguration` from `Microsoft.Extensions.Configuration`)
- Binary formatters (`BinaryFormatter` is disabled by default in modern .NET)

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, including configuration files and static assets, are present before deploying to the target environment.