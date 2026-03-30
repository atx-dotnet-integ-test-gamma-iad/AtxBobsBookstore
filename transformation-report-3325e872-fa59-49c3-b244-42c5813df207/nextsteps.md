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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Review the NuGet packages referenced in each project for any packages that are Windows-only or carry the `windows` target framework moniker (e.g., `net8.0-windows`). Common areas to check:

- `Bookstore.Data`: Verify that the database provider (e.g., Entity Framework Core) is compatible with the target platform.
- `Bookstore.Web`: Confirm that no legacy `System.Web` references remain, as these are not supported on cross-platform .NET.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between .NET Framework and cross-platform .NET.

### 6. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- Database connectivity and data retrieval through `Bookstore.Data`
- Domain logic correctness in `Bookstore.Domain`
- Page rendering and routing in `Bookstore.Web`

### 7. Review Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously held in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication or authorization configuration

### 8. Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is self-contained or framework-dependent based on your deployment requirements. Copy the published output to the target host and confirm the application runs correctly in that environment.