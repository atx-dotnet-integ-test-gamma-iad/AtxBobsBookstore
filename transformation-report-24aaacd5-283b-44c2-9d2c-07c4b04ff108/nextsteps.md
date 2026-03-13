# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Build Status

The solution has no build errors across all three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

This indicates the transformation to cross-platform .NET was completed without introducing any compilation issues.

## Validation Steps

### 1. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a supported cross-platform .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 2. Verify NuGet Package Compatibility

Check that all NuGet packages referenced in each project are compatible with the target framework. Run the following command from the solution root:

```bash
dotnet list package --outdated
```

Update any packages that have newer versions compatible with your target framework.

### 3. Restore and Build the Solution

Run a clean restore and build to confirm the solution compiles correctly from the command line:

```bash
dotnet restore
dotnet build --configuration Release
```

Confirm there are no warnings or errors in the output.

### 4. Run the Data Layer Tests

If there are database migrations or data access logic in `Bookstore.Data`, verify the data layer behaves correctly by running any existing unit or integration tests:

```bash
dotnet test
```

If no tests exist, consider manually verifying that the `DbContext` (if using Entity Framework) can connect to the database and that migrations are up to date:

```bash
dotnet ef database update --project Bookstore.Data
```

### 5. Check for Windows-Specific APIs

Search the codebase for any APIs that may have been available in .NET Framework but are not fully supported cross-platform. Common areas to check include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `Registry` access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage

Use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

### 6. Test the Web Application Locally

Run the `Bookstore.Web` project locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected (if applicable)

### 7. Verify Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and contain the correct configuration values, including connection strings. Ensure that any configuration previously stored in `Web.config` or `App.config` has been migrated appropriately.

### 8. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, if possible, run the application on Linux or macOS to confirm there are no platform-specific runtime issues:

```bash
dotnet run --project Bookstore.Web
```

Observe the application logs for any runtime exceptions that may not have surfaced during the build.

## Deployment

Once validation is complete, publish the application using the following command:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy them to your target hosting environment (e.g., IIS on Windows, or a Linux server using Kestrel behind a reverse proxy such as Nginx or Apache).