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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves correctly after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas in particular:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are up to date by running `dotnet ef database update`.
- **Configuration**: Ensure that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings.
- **Authentication and Authorization**: If any Windows Authentication or legacy ASP.NET membership providers were in use, confirm that the replacement mechanisms are functioning correctly.
- **Static assets and routing**: Navigate through the application to confirm that pages render correctly and routes resolve as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Check for Removed or Changed APIs

Review the code in each project for use of APIs that behave differently on cross-platform .NET compared to .NET Framework. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET
- `BinaryFormatter`, which is disabled by default
- Registry access or Windows-specific file path assumptions
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 7. Publish the Application

Once runtime behavior is confirmed, publish the application to verify the output is complete:

```bash
dotnet publish --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, including configuration files and static assets, are present before deploying to the target environment.