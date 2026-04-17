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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup and routing
- Database connectivity from `Bookstore.Data`
- Domain logic correctness from `Bookstore.Domain`
- Any pages or endpoints that rely on Windows-specific APIs, as these may fail silently at runtime even without build errors

### 5. Check for Platform-Specific API Usage

Even with a clean build, some APIs that were available in .NET Framework may behave differently or be unavailable at runtime on cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to scan for potential issues:

```bash
dotnet tool install -g dotnet-compatibility
```

Pay particular attention to:

- `System.Web` references that may have been replaced with ASP.NET Core equivalents
- Windows Registry access
- `System.Drawing` usage, which requires additional native dependencies on Linux and macOS
- Any use of `AppDomain` or remoting APIs

### 6. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files are present and correctly structured. Verify that connection strings and other settings previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 7. Database Migration Check

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a development database before testing against production data:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.