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

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer

Since `Bookstore.Data` is likely responsible for database access, verify the following:

- The correct version of Entity Framework Core (or whichever ORM is in use) is referenced.
- Connection strings in `appsettings.json` are valid and accessible in the target environment.
- Any database migrations are up to date. If using EF Core, run:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 5. Check Runtime Behavior of the Web Project

Start the `Bookstore.Web` project locally and navigate through the application:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following:

- All pages and routes load without errors.
- Authentication and authorization flows work as expected, if applicable.
- Static assets (CSS, JavaScript, images) are served correctly.
- Any third-party integrations (payment, email, etc.) function as expected.

### 6. Review Configuration Files

Compare the original `Web.config` or `App.config` files with the new `appsettings.json` to ensure all configuration values were carried over, including:

- Connection strings
- Application settings
- Logging configuration
- Any custom configuration sections

### 7. Review Removed Windows-Specific Dependencies

Check that no APIs or libraries that were removed or altered in cross-platform .NET are still being relied upon at runtime. Common areas to inspect include:

- `System.Web` usages (should be replaced with ASP.NET Core equivalents)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- COM interop or P/Invoke calls targeting Windows-only system libraries

### 8. Target Framework Confirmation

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across projects unless there is a specific reason for them to differ.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected files are present, including:

- The main application assembly
- `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`)
- Static web assets under `wwwroot`

### 3. Environment-Specific Configuration

Before deploying to a target environment, confirm that environment-specific settings are configured correctly. ASP.NET Core uses the `ASPNETCORE_ENVIRONMENT` environment variable to select the appropriate configuration. Set this variable on the target host as needed:

```bash
export ASPNETCORE_ENVIRONMENT=Production
```

### 4. Deploy to the Target Host

Copy the published output to the target server or hosting environment and configure the web server (e.g., IIS, Nginx, or Apache) to serve the application according to the [official ASP.NET Core hosting documentation](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/).