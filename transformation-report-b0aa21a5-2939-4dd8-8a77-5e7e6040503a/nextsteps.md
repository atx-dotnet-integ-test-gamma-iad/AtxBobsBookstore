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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, test the following areas which are commonly affected by cross-platform migrations:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to and query the database correctly. If the project previously used SQL Server with Windows Authentication, you may need to update the connection string to use SQL Authentication or a compatible provider.
- **File paths**: Ensure any file I/O operations in the application use `Path.Combine` and relative paths rather than hardcoded Windows-style paths.
- **Configuration**: Verify that `appsettings.json` (or equivalent) contains all necessary configuration values that may have previously been stored in `Web.config` or `App.config`.
- **Authentication and Authorization**: If the application used Windows Authentication or ASP.NET Membership, confirm that the replacement mechanisms are functioning correctly.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy framework, update it to the appropriate cross-platform target.

### 6. Check for Platform-Specific API Usage

Run the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining usage of Windows-only APIs:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze app/Bookstore.Web/Bookstore.Web.csproj
```

Address any flagged APIs by replacing them with cross-platform alternatives from the .NET BCL or appropriate NuGet packages.

### 7. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** is required for cross-platform .NET. The legacy `EntityFramework` (6.x) NuGet package is Windows-compatible but not recommended for new cross-platform targets.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is as expected:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.