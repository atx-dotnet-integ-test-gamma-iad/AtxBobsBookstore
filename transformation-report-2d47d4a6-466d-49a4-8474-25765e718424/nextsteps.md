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

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and the new target framework.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Review Removed or Changed APIs

Check for any use of APIs that existed in .NET Framework but have been removed or altered in cross-platform .NET. Common areas to review include:

- `System.Web` references (these do not exist in cross-platform .NET and must be replaced with ASP.NET Core equivalents).
- `ConfigurationManager` usage, which should be replaced with `Microsoft.Extensions.Configuration`.
- Any Windows-specific APIs (e.g., registry access, certain cryptography APIs) that may not be available on non-Windows platforms.

### 8. Test on Target Platform

If the goal is to run the application on a non-Windows operating system, perform a test run on that platform (e.g., Linux or macOS) to surface any remaining platform-specific issues:

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify application behavior.

## Deployment

### 1. Publish the Application

Generate the deployment artifacts using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify Published Output

Inspect the `./publish` directory to confirm all required files are present, including configuration files and static assets.

### 3. Configure the Production Environment

Ensure the production environment has the correct .NET runtime version installed. Verify this with:

```bash
dotnet --list-runtimes
```

Update `appsettings.json` or use environment variables to supply production-specific configuration values such as connection strings and logging settings.

### 4. Deploy to the Target Server

Copy the contents of the `./publish` directory to the target server and configure the web server (e.g., IIS, Nginx, or Kestrel as a standalone host) to serve the application according to the ASP.NET Core hosting documentation appropriate for your environment.