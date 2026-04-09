# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects (`Bookstore.Data`, `Bookstore.Web`, or `Bookstore.Domain`). The solution compiled cleanly across all projects.

## Validation

### 1. Verify Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element targets a supported cross-platform .NET version (e.g., `net6.0`, `net7.0`, or `net8.0`) rather than a legacy `net48` or `netcoreapp` moniker.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 2. Restore and Build Locally

Run the following commands from the solution root to confirm the build is clean on your local machine:

```bash
dotnet restore
dotnet build --configuration Release
```

Ensure there are no warnings that could indicate deprecated APIs or missing dependencies.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The database provider NuGet package is compatible with the target framework (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Verify Runtime Behavior of Bookstore.Web

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- All routes resolve correctly.
- Static files (CSS, JS, images) are served as expected.
- Authentication and authorization flows work if applicable.
- Any configuration previously stored in `Web.config` has been migrated to `appsettings.json`.

### 6. Check for Removed or Changed APIs

Some .NET Framework APIs are not available or behave differently in cross-platform .NET. Review the code in each project for usage of the following common problem areas:

- `System.Web` namespace — not available in cross-platform .NET.
- `HttpContext` usage outside of a request pipeline.
- `ConfigurationManager` — replaced by `Microsoft.Extensions.Configuration`.
- Binary serialization (`BinaryFormatter`) — disabled by default in .NET 5+.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to scan for any remaining compatibility issues:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

### 7. Review NuGet Package Compatibility

Ensure all NuGet packages referenced across the three projects have versions that support the target framework. Check for any packages that may have been marked as compatible during transformation but are actually .NET Framework-only. The following command can help identify outdated packages:

```bash
dotnet list package --outdated
```

Update packages where necessary using:

```bash
dotnet add package <PackageName> --version <LatestVersion>
```

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Publish Output

Inspect the `./publish` directory to confirm all required files are present, including:

- The application DLLs and executable.
- `appsettings.json` and any environment-specific configuration files.
- Static web assets under `wwwroot` if applicable.

### 3. Configure the Target Environment

Ensure the target server or hosting environment has the correct .NET runtime installed. You can verify the required runtime version from the `.csproj` `<TargetFramework>` value and download the appropriate runtime from [https://dotnet.microsoft.com/download](https://dotnet.microsoft.com/download).

For IIS hosting, ensure the **ASP.NET Core Hosting Bundle** is installed and the application pool is set to **No Managed Code**.